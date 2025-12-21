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

## Finds existing StatusChange or creates a new one, then adds stacks.
func _accumulate_status_change(
	target: BattleParticipant,
	status: StatusTemplateData,
	stacks: int
) -> void:
	# Look for existing change for this target/status combo
	for change in spell_preview_result.status_changes:
		if change.target == target and change.status == status:
			change.stacks += stacks
			return
	
	# No existing change found, create a new one
	var new_change := StatusChange.new(target, status, stacks)
	spell_preview_result.status_changes.append(new_change)

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
	_accumulate_status_change(target, status, stacks)

func remove_status(
	target: BattleParticipant,
	status: StatusTemplateData,
	stacks: int
):
	_accumulate_status_change(target, status, -stacks)
