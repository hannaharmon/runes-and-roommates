class_name ExecutionResolver
extends BattleResolver
## Handles all modifications to BattleContext and BattleParticipants.
##
## Actually applies changes to battle state during spell execution.
## Uses the same calculation logic as PreviewResolver to ensure
## execution matches previews.

var battle_context: BattleContext

func _init(context: BattleContext):
	battle_context = context

func deal_damage(
	source: EffectSource,
	target: BattleParticipant,
	base_amount: int,
	damage_tags: Array[Enums.DamageTag] = []
):
	var final_damage := _calculate_final_damage(source, target, base_amount, damage_tags)
	
	# Apply damage to target
	target.current_health -= final_damage
	if target.current_health < 0:
		target.current_health = 0

func heal(
	source: EffectSource,
	target: BattleParticipant,
	amount: int
):
	var final_heal := _calculate_final_heal(target, amount)
	
	# Apply healing to target
	target.current_health += final_heal
	# _calculate_final_heal already handles max health clamping

func apply_status(
	target: BattleParticipant,
	status: StatusTemplateData,
	stacks: int
):
	var previous_stacks := 0
	if target.statuses.has(status):
		previous_stacks = target.statuses[status]
	else:
		# First time applying this status - call on_apply
		status.on_apply(target, battle_context)
	
	# Add stacks
	target.statuses[status] = previous_stacks + stacks

func remove_status(
	target: BattleParticipant,
	status: StatusTemplateData,
	stacks: int
):
	if not target.statuses.has(status):
		return  # Can't remove a status that isn't present
	
	var current_stacks := target.statuses[status]
	var new_stacks := current_stacks - stacks
	
	if new_stacks <= 0:
		# Status fully removed
		target.statuses.erase(status)
		status.on_remove(target, battle_context)
	else:
		# Still has stacks remaining
		target.statuses[status] = new_stacks
