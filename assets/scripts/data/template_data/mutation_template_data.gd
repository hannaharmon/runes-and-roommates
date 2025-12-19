@abstract 
class_name MutationTemplateData 
extends TemplateData

@export var texutre: Texture2D
@export var appearance_rate: float
@export var required_elements: Array[Enums.Element]
@export var execution_only: bool

func modify_power(power: float) -> float:
	return power

func modify_point_cost(element_points_cost: ElementPoints) -> ElementPoints:
	return element_points_cost

func modify_description(spell_description: String) -> String:
	return spell_description

func before_invoke(
	_casters: Array[BattleParticipant], 
	_targets: Array[BattleParticipant], 
	_context: BattleContext
) -> void:
	pass
	
func after_invoke(
	_casters: Array[BattleParticipant], 
	_targets: Array[BattleParticipant],
	_context: BattleContext
) -> void:
	pass
