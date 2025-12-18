class_name ExecutionResolver
extends BattleResolver
## Handles all modifications to BattleContext and BattleParticipants.

func deal_damage(
	source_spell: Spell,
	target: BattleParticipant,
	base_amount: int,
	damage_tags: Array[Enums.DamageTag] = []
):
	pass #TODO

func heal(
	source_spell: Spell,
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
