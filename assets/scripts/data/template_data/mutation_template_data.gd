@abstract 
class_name MutationTemplateData 
extends TemplateData
## Base class for every mutation in the game to extend.
##
## Should NEVER modify battle context directly -- instead go through the
## resolver that is passed in.

@export var texutre: Texture2D
@export var appearance_rate: float
@export var required_elements: Array[Enums.Element]

# Set to true for mutaitons that should not be applied in preview 
# (ex: randomize target)
@export var execution_only: bool

func modify_power(power: float) -> float:
	return power

func modify_point_cost(element_points_cost: ElementPoints) -> ElementPoints:
	return element_points_cost

func modify_description(spell_description: String) -> String:
	return spell_description

func before_invoke(
	calling_spell: Spell,
	resolver: BattleResolver,
	_casters: Array[BattleParticipant], 
	_targets: Array[BattleParticipant], 
	_battle_context: BattleContext
) -> void:
	pass
	
func after_invoke(
	calling_spell: Spell,
	resolver: BattleResolver,
	_casters: Array[BattleParticipant], 
	_targets: Array[BattleParticipant],
	_battle_context: BattleContext
) -> void:
	pass
