@abstract
class_name BattleResolver
extends RefCounted
## Base class for ExecutionResolver and PreviewResolver to extend.
##
## PreviewResolver and ExecutionResolver can be used interchangeably to 
## either examine effects without changing state or actually change state.
##
## All changes to battle state MUST go through resolvers and be implemented by
## both derived resolvers.
##
## The shared calculation methods (_calculate_*) ensure both resolvers
## compute identical values. Derived classes only differ in how they apply
## or record these calculated values.

# ============================================================================
# PUBLIC API - Must be implemented by derived classes
# ============================================================================

@abstract func deal_damage(
	source: EffectSource,
	target: BattleParticipant,
	base_amount: int,
	damage_tags: Array[Enums.DamageTag] = []
)

@abstract func heal(
	source: EffectSource,
	target: BattleParticipant,
	amount: int
)

@abstract func apply_status(
	target: BattleParticipant,
	status: StatusTemplateData,
	stacks: int
)

@abstract func remove_status(
	target: BattleParticipant,
	status: StatusTemplateData,
	stacks: int
)

# ============================================================================
# SHARED CALCULATION LOGIC - Used by both resolvers
# ============================================================================

## Calculates final damage after all modifiers.
## This is the single source of truth for damage calculation.
func _calculate_final_damage(
	source: EffectSource,
	target: BattleParticipant,
	base_amount: int,
	damage_tags: Array[Enums.DamageTag]
) -> int:
	var damage := float(base_amount)
	
	# Apply type advantage multiplier based on damage source vs target elements
	# (Note: caster element_ratios are NOT used for type advantages)
	var type_multiplier := TypeAdvantageCalculator.calculate_type_advantage_multiplier(
		source.element_ratio,
		target.get_element_ratio()
	)
	damage *= type_multiplier
	
	# Apply status modifiers from target's active statuses
	for status: StatusTemplateData in target.statuses:
		damage = status.modify_incoming_damage(damage, damage_tags)
	
	# Apply status modifiers from source (if damage comes from a status DOT)
	if source.status != null:
		damage = source.status.modify_outgoing_damage(damage, damage_tags)
	
	return int(damage)

## Calculates final heal amount after clamping to max health.
func _calculate_final_heal(
	target: BattleParticipant,
	amount: int
) -> int:
	var final_amount := amount
	var new_health := target.current_health + final_amount
	
	# Clamp to max health
	if new_health > target.max_health:
		final_amount = target.max_health - target.current_health
	
	return final_amount
