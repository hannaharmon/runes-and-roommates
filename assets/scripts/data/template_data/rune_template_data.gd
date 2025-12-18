@abstract 
class_name RuneTemplateData 
extends TemplateData

@export var texture: Texture2D

func _invoke_rune(
	_casters: Array[BattleParticipant], 
	_targets: Array[BattleParticipant], 
	_context: BattleContext
) -> void:
	pass
