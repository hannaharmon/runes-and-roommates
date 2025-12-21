# Resource Creation Workflow

## What Gets Created Where

### Script Files (.gd) - Behavioral Logic
These are code files that define behavior:

**Runes** (`assets/scripts/data/template_data/runes/`)
- `hit_one_rune.gd` extends `RuneTemplateData`
- `hit_all_rune.gd` extends `RuneTemplateData`
- etc.

**Mutations** (`assets/scripts/data/template_data/mutations/`)
- `smoldering_mutation.gd` extends `MutationTemplateData`
- `piercing_mutation.gd` extends `MutationTemplateData`
- etc.

**Statuses** (`assets/scripts/data/template_data/statuses/`)
- `burning_status.gd` extends `StatusTemplateData`
- `sleep_status.gd` extends `StatusTemplateData`
- etc.

### Resource Files (.tres) - Data Only
These are created in the Godot editor:

**Inks** (`assets/data/inks/`)
- `volcanic_ink.tres` (InkTemplateData)
  - Set id, name, power
  - Click "New ElementRatio" inline, set ratios

**Materials** (`assets/data/materials/`)
- `fire_crystal.tres` (MaterialTemplateData)
  - Set id, name, power
  - Click "New ElementRatio" inline, set ratios

**Monsters** (`assets/data/monsters/`)
- `fire_golem.tres` (MonsterTemplateData)
  - Set id, name
  - Click "New ElementRatio" inline, set ratios
  - Assign drops (MaterialTemplateData references)

**Characters** (`assets/data/characters/`)
- `protagonist.tres` (CharacterTemplateData)
  - Set id, name
  - Click "New ElementRatio" inline, set ratios

## Never Do This
❌ Create separate `.tres` files for ElementRatio  
❌ Create `.tres` files for runes/mutations/statuses  
❌ Store element ratios as separate resources  

## Always Do This
✅ Create ElementRatio inline in inspector ("New ElementRatio")  
✅ Keep runes/mutations/statuses as `.gd` script files  
✅ Only create `.tres` for data-only templates (inks, materials, monsters, characters)
