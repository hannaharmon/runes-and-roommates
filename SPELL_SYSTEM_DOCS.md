# Spell System Architecture Documentation

## Overview

This document describes the complete spell-crafting and battle system architecture for the deckbuilder game.

## Core Concepts

### Template Data vs Save Data vs Runtime

- **Template Data**: Immutable game definitions (what an ink/rune/monster *is*)
- **Save Data**: Mutable player state (what the player *owns* or has *done*)
- **Runtime Classes**: Active game objects that use Template + Save data to execute behavior

### The Resolver Pattern

The system uses a resolver pattern to enable accurate spell previews:
- `BattleResolver` (abstract base) defines the calculation logic
- `PreviewResolver` accumulates results without modifying state
- `ExecutionResolver` applies changes to actual battle state
- Both use **identical calculations** to ensure previews match execution

## System Components

### 1. Template Data Classes

#### Base Template
- `TemplateData` - Base class with id, name, description

#### Behavioral Templates (Abstract)
These define behavior through code and should be subclassed:
- `RuneTemplateData` - Defines spell effects (damage, healing, etc.)
  - Create as `.gd` script files, NOT `.tres` resources
  - Example: `hit_one_rune.gd` extends `RuneTemplateData`
- `MutationTemplateData` - Modifies spell behavior/stats
  - Create as `.gd` script files, NOT `.tres` resources
  - Example: `smoldering_mutation.gd` extends `MutationTemplateData`
- `StatusTemplateData` - Defines status effect behavior
  - Create as `.gd` script files, NOT `.tres` resources
  - Example: `burning_status.gd` extends `StatusTemplateData`
- `CreatureTemplateData` - Base for characters/monsters

#### Data-Only Templates
These just hold data and are instantiated as `.tres` resources:
- `InkTemplateData` - Element ratio + power (used to craft spells)
  - Create inline `ElementRatio` in inspector, don't make separate `.tres` files
- `MaterialTemplateData` - Element ratio + power (used to craft inks)
  - Create inline `ElementRatio` in inspector
- `MonsterTemplateData` - Monster stats and drops
  - Create inline `ElementRatio` in inspector
- `CharacterTemplateData` - Character base stats
  - Create inline `ElementRatio` in inspector

#### ElementRatio Workflow
`ElementRatio` extends `Resource` (not `RefCounted`) only for serialization purposes.
**Never create separate `.tres` files for element ratios!** Instead:
1. In any template's `element_ratio` field, click "New ElementRatio"
2. Set the ratio dictionary directly in the inspector
3. That's it - no separate file needed

### 2. Save Data Classes

- `GameSaveData` - Top-level save containing all player progress
- `SpellSaveData` - A player-created spell (ink + rune + mutations + name)
- `InkSaveData` / `MaterialSaveData` - Inventory items (id + quantity)
- `CharacterSaveData` - Character progression (level, relationships)
- `MonsterSaveData` - Monster discovery tracking (kills, discovered)
- `ItemSaveData` - Base class for inventory items

### 3. Runtime Classes

#### Spell System
- `Spell` - Runtime spell that compiles costs/power/description and executes via resolvers
  - Uses `SpellSaveData` for configuration
  - Calls `_compile_spell()` to calculate final stats after mutations
  - `preview()` - Shows what would happen without modifying state
  - `cast()` - Actually executes the spell

#### Battle System
- `BattleContext` - Holds player_team and enemy_team arrays
- `BattleParticipant` - Base class for any battle entity
  - `current_health`, `max_health`, `element_ratio`
  - `statuses` dictionary tracking active status effects
- `CharacterBattleParticipant` - Player party members
- `MonsterBattleParticipant` - Enemies

#### Resolvers
- `BattleResolver` (abstract)
  - `deal_damage()` - Apply damage with type advantages
  - `heal()` - Restore health (capped at max)
  - `apply_status()` - Add status effect stacks
  - `remove_status()` - Remove status effect stacks
  - `_calculate_final_damage()` - Shared calculation logic
  - `_calculate_final_heal()` - Shared calculation logic
  
- `PreviewResolver` - Accumulates results in `SpellPreviewResult`
- `ExecutionResolver` - Modifies battle state directly

### 4. Helper Classes

- `ElementRatio` - Dictionary mapping elements to their ratios (must sum to 1.0)
- `ElementPoints` - Dictionary mapping elements to integer point costs
- `ElementCalculator` - Converts power + ratio into point costs
- `TypeAdvantageCalculator` - Calculates damage multipliers from type matchups
- `EffectSource` - Tracks what caused an effect (spell, status, mutation)
- `SpellPreviewResult` - Aggregates preview data for UI display
- `TemplateRegistry` - Maps template IDs to template instances
- `DescriptionFormatter` - Converts descriptions to BBCode for UI

### 5. Enums

```gdscript
enum Element {
    FIRE, WATER, EARTH,
    METAL, BEAST,
    DARK, LIGHT
}

enum DamageTag {
    DOT,      // Damage over time
    PIERCING  // Ignores certain defenses
}
```

## Type Advantage System

Type advantages multiply damage based on the **damage source's element ratio** versus the **target's element ratio**. This applies to any damage source: spells, status effects (like Burn DOT), etc.

**IMPORTANT**: The caster's element_ratio is **NOT** used for type advantage calculations. It serves two different purposes:
1. **Defensive**: When the caster is a target, their element_ratio affects incoming damage
2. **Spell Casting**: Their element_points (derived from element_ratio) determines which spells they can cast

### Advantages
- Fire > Earth
- Water > Fire
- Earth > Water
- Dark > Light
- Light > Dark
- Metal and Beast are neutral (no advantages)

### Calculation
For each element in the damage source that has advantage over a target element:
```
multiplier += damage_source_ratio * target_ratio
```

**Example**: 0.25 Water damage hitting 0.5 Fire monster
- Base multiplier: 1.0
- Water advantage over Fire: 0.25 * 0.5 = 0.125
- Final multiplier: 1.125 (12.5% bonus damage)

This works for spells, status DOTs, or any other damage with an element ratio.

### Element Points and Spell Casting

Casters use their element_ratio to generate element_points, which are spent to cast spells:
1. Each caster has an element_ratio (e.g., Fire=0.6, Earth=0.4)
2. This generates element_points available for casting
3. Spells have an element_points_cost based on their ink's power and ratio
4. The combined element_points of all casters must meet the spell's cost to cast it

## Spell Crafting Flow

1. **Player gathers Materials** from defeated monsters
2. **Player crafts Ink** by combining materials
   - Resulting ink has element ratio/power based on materials used
   - Ink matches one of the predefined InkTemplateData instances
3. **Player crafts Spell** using:
   - One Ink (determines power, element ratio, cost)
   - One Rune (determines effect - damage, heal, buff, etc.)
   - 0+ Mutations (modify behavior - extra effects, stat changes)
4. **Spell is compiled** - final stats calculated
5. **Spell added to player's collection**
6. **Player builds deck** by selecting spells to use in battle

## Creating New Content

### New Rune (e.g., "HitAll" that damages all enemies)

```gdscript
class_name HitAllRune
extends RuneTemplateData

func invoke_rune(
    calling_spell: Spell,
    resolver: BattleResolver,
    _casters: Array[BattleParticipant], 
    targets: Array[BattleParticipant], 
    _context: BattleContext
) -> void:
    var source := EffectSource.new()
    source.spell = calling_spell
    
    for target in targets:
        resolver.deal_damage(source, target, int(calling_spell.power), [])
```

### New Mutation (e.g., "Piercing" that ignores defense)

```gdscript
class_name PiercingMutation
extends MutationTemplateData

func before_invoke(
    calling_spell: Spell,
    resolver: BattleResolver,
    _casters: Array[BattleParticipant], 
    _targets: Array[BattleParticipant], 
    _battle_context: BattleContext
) -> void:
    # Add PIERCING tag to damage calls
    # (Implementation would require passing tags through spell invoke)
    pass

func modify_description(spell_description: String) -> String:
    return spell_description + " [Piercing]"
```

### New Status Effect (e.g., "Burning" DOT)

```gdscript
class_name BurningStatus
extends StatusTemplateData

func on_turn_start(
    target: BattleParticipant,
    resolver: BattleResolver,
    _context: BattleContext
) -> void:
    if not target.statuses.has(self):
        return
    
    var stacks := target.statuses[self]
    
    # Deal Fire damage equal to stacks
    var source := EffectSource.new(null, self)
    resolver.deal_damage(source, target, stacks, [Enums.DamageTag.DOT])
    
    # Decrease stacks by 1
    target.statuses[self] -= 1
    if target.statuses[self] <= 0:
        target.statuses.erase(self)
        on_remove(target, _context)
```

**Note**: Status hooks (`on_apply`, `on_remove`, `on_turn_start`) now receive
`BattleResolver` and `BattleContext` parameters, allowing statuses to deal damage,
heal, and apply other effects properly.

## Design Strengths

1. ✅ **Preview/Execution parity** - Identical calculations ensure accuracy
2. ✅ **Clean separation** - Template/Save/Runtime cleanly separated
3. ✅ **Extensible behavior** - Easy to add new runes/mutations/statuses
4. ✅ **Type-safe** - Strong typing with class_name throughout
5. ✅ **Testable** - Can test preview without side effects

## Design Considerations

### Current Limitations

1. **Status effects can't deal damage/healing yet**
   - StatusTemplateData doesn't have access to resolvers
   - Solution: Pass resolver to `on_turn_start()` and other hooks
   
2. **No max status stack limits**
   - May want to add `@export var max_stacks: int` to StatusTemplateData
   
3. **Battle context is minimal**
   - No turn tracking, no event queue, no timing system
   - These may be needed for turn-based combat
   
4. **No animation/VFX hooks**
   - Resolvers only handle logic, not presentation
   - May want to emit signals for animations

### Recommended Next Steps

1. **Create status effect examples** (Burn, Sleep, Poison, etc.)
2. **Add resolver access to status effects** for DOT damage
3. **Implement turn management** in BattleContext
4. **Create more example runes** (AoE, heals, buffs)
5. **Build UI** for spell preview display
6. **Add VFX/animation system** separate from resolvers
7. **Implement deck management** system
8. **Create save/load serialization** for GameSaveData

## File Structure

```
assets/scripts/
├── data/
│   ├── save_data/              # Player state
│   └── template_data/          # Game definitions
│       ├── runes/              # Rune implementations
│       ├── mutations/          # Mutation implementations
│       └── statuses/           # Status implementations
├── runtime/
│   ├── spell.gd               # Spell execution
│   └── battles/
│       ├── battle_context.gd
│       ├── battle_participant.gd
│       └── resolvers/
│           ├── battle_resolver.gd
│           ├── preview_resolver.gd
│           └── execution_resolver.gd
├── helpers/
│   ├── element_*.gd           # Element calculations
│   ├── type_advantage_calculator.gd
│   └── template_registry.gd
└── enums/
    └── enums.gd
```

## Testing the System

See `examples/spell_system_example.gd` for a complete working example that:
1. Creates ink, rune, and mutations
2. Crafts a spell
3. Sets up a battle
4. Previews the spell
5. Casts the spell
6. Verifies the results

Run this scene to see the spell system in action!
