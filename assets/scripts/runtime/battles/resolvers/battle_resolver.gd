@abstract
class_name BattleResolver
## Base class for ExectuionResolver and PreviewResolver to extend.
##
## PreviewResolver and ExecutionResolver can be used interchangeably to 
## either examine effects without changing state or actually change state.
##
## All changes to battle state MUST go through resolvers and be implemented by
## both derived resolvers.
##
## These functions only worry about the last step of damage calculation, which
## is type advantages. This is why they only need to know the source spell
## and the target -- other multipliers have already been factored in.

@abstract func deal_damage(
	source_spell: Spell,
	target: BattleParticipant,
	base_amount: int,
	damage_tags: Array[Enums.DamageTag] = []
)

@abstract func heal(
	source_spell: Spell,
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
