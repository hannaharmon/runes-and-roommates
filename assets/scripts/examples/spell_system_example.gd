extends Node
## Example demonstrating the spell system in action.
##
## IMPORTANT: To run this example, you need to create the following resource files
## in the Godot editor first:
## 
## 1. assets/data/inks/volcanic_ink.tres (InkTemplateData)
##    - Set id = "volcanic_ink", name = "Volcanic Ink", power = 50
##    - In the element_ratio field, click "New ElementRatio"
##    - Set the ratio dictionary: {FIRE: 0.5, EARTH: 0.5}
## 
## 2. assets/data/characters/fire_character.tres (CharacterTemplateData)
##    - Set id = "fire_character", name = "Fire Character"
##    - Set base_health = 100
##    - In the element_ratio field, click "New ElementRatio"
##    - Set the ratio dictionary: {FIRE: 0.5, EARTH: 0.5}
## 
## 3. assets/data/monsters/water_monster.tres (MonsterTemplateData)
##    - Set id = "water_monster", name = "Water Monster"
##    - Set base_health = 100
##    - In the element_ratio field, click "New ElementRatio"
##    - Set the ratio dictionary: {WATER: 1.0}
##
## NOTE: Runes, Statuses, and Mutations are implemented purely in .gd scripts.
## You do NOT create .tres files for them. This example instantiates them in code
## using the scripts located under assets/scripts/data/template_data/.
##
## This script shows how to:
## 1. Load template data from resources
## 2. Create a spell from ink, rune, and mutations
## 3. Preview what the spell will do
## 4. Cast the spell and apply changes to battle state

# Preload template resources (create these in the editor!)
@export var volcanic_ink: InkTemplateData
@export var fire_character_template: CharacterTemplateData
@export var water_monster_template: MonsterTemplateData

func _ready():
	if not _validate_resources():
		return
	example_spell_cast()

func _validate_resources() -> bool:
	if volcanic_ink == null:
		push_error("volcanic_ink not assigned! Assign it in the inspector.")
		return false
	if fire_character_template == null:
		push_error("fire_character_template not assigned! Assign it in the inspector.")
		return false
	if water_monster_template == null:
		push_error("water_monster_template not assigned! Assign it in the inspector.")
		return false
	return true

func example_spell_cast():
	print("=== Spell System Example ===\n")
	
	var hit_one_rune := HitOneRune.new()
	var smoldering_mutation := SmolderingMutation.new()
	
	# Create spell save data (this is what the player actually owns)
	var spell_data := SpellSaveData.new(
		"Volcanic Strike",
		volcanic_ink,
		hit_one_rune,
		[smoldering_mutation]
	)
	
	# Create the runtime spell (this compiles the spell)
	var spell := Spell.new(spell_data)
	
	print("Spell: ", spell_data.name)
	print("Ink Power: ", volcanic_ink.power)
	print("Spell Compiled Power: ", spell.power)
	print("Spell Element Ratio: Fire=", spell.element_ratio.ratio[Enums.Element.FIRE], 
		  " Earth=", spell.element_ratio.ratio[Enums.Element.EARTH])
	print("Description: ", spell.description)
	print()
	# Create battle participants using templates
	# Player controls a character, so we need CharacterSaveData for it
	var player_save := CharacterSaveData.new(fire_character_template.id, 1)
	
	var player_character := CharacterBattleParticipant.new(fire_character_template, player_save, true)
	var enemy_monster := MonsterBattleParticipant.new(water_monster_template, false)
	
	# Create battle context
	var battle := BattleContext.new()
	battle.player_team = [player_character]
	battle.enemy_team = [enemy_monster]
	
	var casters: Array[BattleParticipant] = [player_character]
	var targets: Array[BattleParticipant] = [enemy_monster]
	
	print("Attacker: Fire/Earth creature")
	print("Defender: Water creature (weak to Earth)")
	var fire_ratio = volcanic_ink.element_ratio
	var water_ratio = water_monster_template.element_ratio
	print("Expected type advantage: ", 
		  fire_ratio.ratio[Enums.Element.EARTH], " earth * ",
		  water_ratio.ratio[Enums.Element.WATER], " water = +",
		  fire_ratio.ratio[Enums.Element.EARTH] * water_ratio.ratio[Enums.Element.WATER],
		  " multiplier")
	print()
	
	# PREVIEW the spell
	print("--- PREVIEW ---")
	var preview := spell.preview(casters, targets, battle)
	for target in preview.damage_by_target:
		var damage: int = preview.damage_by_target[target]
		print("Will deal ", damage, " damage to target")
		print("(Base: ", spell.power, " * Type advantage multiplier)")
	
	for status_change in preview.status_changes:
		print("Will apply ", status_change.stacks, " stacks of ", status_change.status.name, " to target")
	print()
	
	# CAST the spell
	print("--- CASTING ---")
	print("Enemy HP before: ", enemy_monster.current_health)
	spell.cast(casters, targets, battle)
	print("Enemy HP after: ", enemy_monster.current_health)
	print("Damage dealt: ", 100 - enemy_monster.current_health)
	
	print("Enemy statuses:")
	if enemy_monster.statuses.is_empty():
		print("  (none)")
	else:
		for status in enemy_monster.statuses:
			var stacks = enemy_monster.statuses[status]
			print("  - ", status.name, ": ", stacks, " stack(s)")
	print()
	
	print("=== Example Complete ===")
