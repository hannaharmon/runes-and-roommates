extends Node
## Example demonstrating the spell system in action.
##
## This script shows how to:
## 1. Create a spell from ink, rune, and mutations
## 2. Preview what the spell will do
## 3. Cast the spell and apply changes to battle state

func _ready():
	example_spell_cast()

func example_spell_cast():
	print("=== Spell System Example ===\n")
	
	# Create element ratios
	var fire_ratio := ElementRatio.new()
	fire_ratio.ratio = {Enums.Element.FIRE: 0.5, Enums.Element.EARTH: 0.5}
	
	var water_ratio := ElementRatio.new()
	water_ratio.ratio = {Enums.Element.WATER: 1.0}
	
	# Create an ink template (50 power, fire/earth mix)
	var fire_ink := InkTemplateData.new()
	fire_ink.id = "fire_earth_ink"
	fire_ink.name = "Volcanic Ink"
	fire_ink.power = 50
	fire_ink.element_ratio = fire_ratio
	
	# Create a rune template (HitOne - damages single target)
	var hit_one := HitOneRune.new()
	hit_one.id = "hit_one"
	hit_one.name = "Strike"
	hit_one.description = "Deal damage to one enemy."
	
	# Create a mutation (Empowered - increases power)
	var empowered := EmpoweredMutation.new()
	empowered.id = "empowered"
	empowered.name = "Empowered"
	empowered.appearance_rate = 0.15
	
	# Create spell save data
	var spell_data := SpellSaveData.new()
	spell_data.name = "Volcanic Strike"
	spell_data.ink = fire_ink
	spell_data.rune = hit_one
	spell_data.mutations = [empowered]
	
	# Create the runtime spell (this compiles the spell)
	var spell := Spell.new(spell_data)
	
	print("Spell: ", spell_data.name)
	print("Base Power: ", fire_ink.power)
	print("Compiled Power: ", spell.power, " (with Empowered: +50%)")
	print("Element Ratio: Fire=", fire_ratio.ratio[Enums.Element.FIRE], 
		  " Earth=", fire_ratio.ratio[Enums.Element.EARTH])
	print("Description: ", spell.description)
	print()
	
	# Create battle participants
	var player_monster := MonsterBattleParticipant.new(create_fire_monster())
	player_monster.is_ally = true
	player_monster.max_health = 100
	player_monster.current_health = 100
	
	var enemy_monster := MonsterBattleParticipant.new(create_water_monster())
	enemy_monster.is_ally = false
	enemy_monster.max_health = 100
	enemy_monster.current_health = 100
	
	# Create battle context
	var battle := BattleContext.new()
	battle.player_team = [player_monster]
	battle.enemy_team = [enemy_monster]
	
	var casters: Array[BattleParticipant] = [player_monster]
	var targets: Array[BattleParticipant] = [enemy_monster]
	
	print("Attacker: Fire/Earth creature (", fire_ratio.ratio[Enums.Element.FIRE], " fire)")
	print("Defender: Water creature (weak to Earth, resists Fire)")
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
	print()
	
	# CAST the spell
	print("--- CASTING ---")
	print("Enemy HP before: ", enemy_monster.current_health)
	spell.cast(casters, targets, battle)
	print("Enemy HP after: ", enemy_monster.current_health)
	print("Damage dealt: ", 100 - enemy_monster.current_health)
	print()
	
	print("=== Example Complete ===")

func create_fire_monster() -> MonsterTemplateData:
	var template := MonsterTemplateData.new()
	template.id = "fire_creature"
	template.name = "Fire Creature"
	
	var ratio := ElementRatio.new()
	ratio.ratio = {Enums.Element.FIRE: 0.5, Enums.Element.EARTH: 0.5}
	template.element_ratio = ratio
	
	return template

func create_water_monster() -> MonsterTemplateData:
	var template := MonsterTemplateData.new()
	template.id = "water_creature"
	template.name = "Water Creature"
	
	var ratio := ElementRatio.new()
	ratio.ratio = {Enums.Element.WATER: 1.0}
	template.element_ratio = ratio
	
	return template
