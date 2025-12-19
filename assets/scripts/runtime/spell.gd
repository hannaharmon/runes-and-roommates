class_name Spell
## Runtime version of a Spell.
##
## Uses information stored in SpellSaveData to compile final power, cost,
## and description as well as define cast behavior.
## The preview function can be used to see information about what will happen
## on cast without modifying battle state.

var data: SpellSaveData

func _init(spell_save_data: SpellSaveData):
	data = spell_save_data
	_compile_spell()

# Not found until after _compile_spell is executed
var compiled: bool = false
var power: float
var element_points_cost: ElementPoints
var element_ratio: ElementRatio
var description: String

func _compile_spell():
	
	# take base information from ink and rune
	power = data.ink.power
	element_ratio = data.ink.element_ratio
	description = data.rune.description
	
	# calculate element points
	element_points_cost = ElementCalculator.calculate_points(power, element_ratio)
	
	# apply mutations
	for m: MutationTemplateData in data.mutations:
		power = m.modify_power(power)
		element_points_cost = m.modify_point_cost(element_points_cost)
		description = m.modify_description(description)
	
	compiled = true

func _invoke_internal(
	resolver: BattleResolver,
	casters: Array[BattleParticipant], 
	targets: Array[BattleParticipant],
	battle_context: BattleContext
) -> void:
	pass #TODO

func preview(
	casters: Array[BattleParticipant], 
	targets: Array[BattleParticipant],
	battle_context: BattleContext
) -> SpellPreviewResult:
	return null #TODO

func cast(
	casters: Array[BattleParticipant], 
	targets: Array[BattleParticipant],
	battle_context: BattleContext
) -> void:
	pass #TODO
