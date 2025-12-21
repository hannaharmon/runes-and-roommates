class_name BurningStatus
extends StatusTemplateData
## Deals pure Fire damage based on stacks and decreases by 1 every turn.

func _init():
	id = "burning"
	name = "Burning"
	var ratio := ElementRatio.new()
	ratio.ratio = {Enums.Element.FIRE: 1.0}
	element_ratio = ratio

func on_turn_start(
	target: BattleParticipant,
	resolver: BattleResolver,
	_context: BattleContext
) -> void:
	var status_key := self as StatusTemplateData
	if not target.statuses.has(status_key):
		return
	
	var stacks := target.statuses[status_key]
	
	# Deal Fire damage equal to stacks
	var source := EffectSource.new(null, self)
	resolver.deal_damage(source, target, stacks, [Enums.DamageTag.DOT])
	
	# Decrease stacks by 1
	target.statuses[status_key] -= 1
	if target.statuses[status_key] <= 0:
		target.statuses.erase(status_key)
		on_remove(target, _context)
