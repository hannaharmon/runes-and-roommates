@abstract
class_name BattleResolver
## Base class for ExectuionResolver and PreviewResolver to extend.
##
## PreviewResolver and ExecutionResolver can be used interchangeably to 
## either examine effects without changing state or actually change state.
## All changes to battle state MUST go through resolvers and be implemented by
## both derived resolvers.

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
