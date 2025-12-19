class_name PreviewResolver
extends BattleResolver
## Allows previewing of what will happen when a Spell is cast.
##
## Accumulates results without modifying actual battle state.
## Uses the same calculation logic as ExecutionResolver to ensure
## preview accuracy.

var spell_preview_result: SpellPreviewResult

func _init():
	spell_preview_result = SpellPreviewResult.new()

func deal_damage(
	source: EffectSource,
	target: BattleParticipant,
	base_amount: int,
	damage_tags: Array[Enums.DamageTag] = []
):
	var final_damage := _calculate_final_damage(source, target, base_amount, damage_tags)
	
	# Accumulate damage for preview
	if not spell_preview_result.damage_by_target.has(target):
		spell_preview_result.damage_by_target[target] = 0
	spell_preview_result.damage_by_target[target] += final_damage

func heal(
	source: EffectSource,
	target: BattleParticipant,
	amount: int
):
	var final_heal := _calculate_final_heal(target, amount)
	
	# Accumulate healing for preview
	if not spell_preview_result.heal_by_target.has(target):
		spell_preview_result.heal_by_target[target] = 0
	spell_preview_result.heal_by_target[target] += final_heal

func apply_status(
	target: BattleParticipant,
	status: StatusTemplateData,
	stacks: int
):
	# Record status application for preview
	if not spell_preview_result.statuses_applied.has(target):
		spell_preview_result.statuses_applied[target] = {}
	
	var target_statuses: Dictionary = spell_preview_result.statuses_applied[target]
	if not target_statuses.has(status):
		target_statuses[status] = 0
	target_statuses[status] += stacks

func remove_status(
	target: BattleParticipant,
	status: StatusTemplateData,
	stacks: int
):
	# Record status removal for preview (negative stacks)
	if not spell_preview_result.statuses_applied.has(target):
		spell_preview_result.statuses_applied[target] = {}
	
	var target_statuses: Dictionary = spell_preview_result.statuses_applied[target]
	if not target_statuses.has(status):
		target_statuses[status] = 0
	target_statuses[status] -= stacks
