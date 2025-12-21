# Spellcraft RPG – Project Overview

## Engine
Godot and GDScript

## Genre
Turn-based AND Real-time combat deckbuilding RPG focused on elemental interactions and spell construction

## Project Scope
Solo, multi-year project. Architecture prioritizes clarity, predictability, and long-term maintainability over rapid iteration.

---

## Core Concept

Players create spells by combining:

- Inks – define base power and elemental ratio
- Runes – define what the spell actually does

Mutations can randomly appear on created spells that satisfy the required elements. They can modify power, cost, behavior, targeting, etc.

Combat emphasizes transparent previews and deterministic outcomes, with controlled randomness applied only at execution time.

---

## Design Pillars

### Predictable Previews
- Hovering a spell over a target shows exactly what will happen to the battle state once the spell is cast
- Some runes/mutations introduce randomness:
  - These do not reveal random outcomes in preview
  - Random effects are applied only during execution

### Strong Data Separation
The project uses three distinct layers:

| Layer | Purpose |
|-----|--------|
| TemplateData | Immutable, authored content (inks, runes, mutations, statuses, creatures) |
| SaveData | Mutable, serialized progression state |
| Runtime Objects | Battle logic, spell compilation, preview, and execution |

These layers must never be blurred.

Note that templates that contain behavior (runes, statuses, mutations) are implemented as derived classes rather than .tres instances of the base template class. 

---

## Combat Overview

### Battle Participants
Characters and monsters are represented at runtime as BattleParticipants.

They track:
- Current health and armor
- Active statuses (with stacks)
- References to their template data

### Casting Spells
Every battle participant has element points determined by their element ratio and their level. Every spell has an element point cost determined by their element ratio and their power. Mutliple battle participants on a team can work together to fulfill the element point requirements to cast one spell.

### Status System
Statuses are stack-based and defined via templates.

Examples:
- Armor: blocks direct damage, not DOT
- Burning: does pure fire damage and decreases by 1 every turn
- Regen: heals and decreases by 1 every turn
- Dizzy: prevents casting (decreases by 1 every turn)
- Empowered: increases outgoing damage (consumed on cast)
- Weakened: decreases outgoing damage (consumed on cast)
- Thorns: casters of spells that damage this enemy take pure earth damage

Statuses may:
- Modify incoming damage
- Modify outgoing damage
- Trigger logic on apply
- Trigger logic at turn start
- Trigger logic when things happen to this participant

---

## Spells

### Spell Composition
A spell consists of:
- One Ink
- One Rune
- Zero or more Mutations

### Spell Compilation
When a spell is compiled:
1. Base power and element ratio come from the ink
2. Base cost is calculated from power and ratio
3. Mutations modify power, cost, and description
4. Final compiled values are cached for UI display under neutral conditions

### Preview vs Execution
Both preview and execution use the same invocation path.
The only difference is which resolver is used.

---

## Resolver Pattern (Critical)

All game state changes must go through a resolver.

### PreviewResolver
- Simulates spell effects
- Accumulates results for UI display
- Does not mutate battle state

### ExecutionResolver
- Applies actual effects to the battle
- Modifies health, armor, statuses, etc.

Runes and mutations never directly change game state — they call resolver methods like:
- deal_damage
- heal
- apply_status
- remove_statuses

---

## Randomness & Mutations

Some mutations:
- Add random targets
- Redirect effects

These mutations are marked execution-only:
- Ignored during preview
- Applied only during spell execution

The preview must never lie, but may intentionally omit information.

---

## UI & Text

- All descriptions are stored as plain strings
- Text formatting (colors, icons, keywords) is applied at render time
- A custom description parsing system is expected
- Template and save data must remain UI-agnostic

---

## Implementation Guidelines

IMPORTANT:
- Inspect existing scripts before suggesting changes
- Make sure you update doccumentation and related scripts when modifying one
- Many architectural decisions are intentional and already implemented
- Extend existing patterns instead of introducing new paradigms
- Runtime objects are typically RefCounted, not Node
- Templates and SaveData are Resources

Avoid:
- Converting everything into Nodes
- Collapsing template/save/runtime layers

---

## Development Philosophy

- Explicit > clever
- Predictable > surprising
- Maintainable > fast

This project is built for longevity.
