@abstract
class_name StatusTemplateData 
extends TemplateData

@export var texture: Texture2D
@export var element_ratio: ElementRatio  # Optional: for statuses that deal elemental damage

func on_apply(_target: BattleParticipant) -> void:
	pass

func on_remove(_target: BattleParticipant) -> void:
	pass

func on_turn_start(_target: BattleParticipant) -> void:
	pass

func modify_incoming_damage(
	amount: float, 
	_damage_tags: Array[Enums.DamageTag]
) -> float:
	return amount

func modify_outgoing_damage(
	amount: float, 
	_damage_tags: Array[Enums.DamageTag]
) -> float:
	return amount
