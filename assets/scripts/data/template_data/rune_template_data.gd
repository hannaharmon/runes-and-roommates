@abstract 
class_name RuneTemplateData 
extends TemplateData
## Base class for every rune in the game to inherit.
##
## Should NEVER modify battle context directly -- instead go through the
## resolver that is passed in.

@export var texture: Texture2D
@export var target_team: Enums.TargetTeam
@export var target_scope: Enums.TargetScope

func invoke_rune(
	calling_spell: Spell,
	resolver: BattleResolver,
	_casters: Array[BattleParticipant], 
	_targets: Array[BattleParticipant], 
	_context: BattleContext
) -> void:
	pass
