class_name PreviewResolver
extends BattleResolver
## Allows previewing of what will happen when a Spell is cast.
##
## 

var spell_preview_result: SpellPreviewResult

func deal_damage(
	source: EffectSource,
	target: BattleParticipant,
	base_amount: int,
	damage_tags: Array[Enums.DamageTag] = []
):
	pass #TODO

func heal(
	source: EffectSource,
	target: BattleParticipant,
	amount: int
):
	pass #TODO

func apply_status(
	target: BattleParticipant,
	status: StatusTemplateData,
	stacks: int
):
	pass #TODO

func remove_status(
	target: BattleParticipant,
	status: StatusTemplateData,
	stacks: int
):
	pass #TODO
