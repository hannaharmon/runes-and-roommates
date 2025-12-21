class_name SmolderingMutation
extends MutationTemplateData
## Applies 2 stacks of Burning status to the target after the spell resolves.

@export var burning_status: BurningStatus

func _init():
	id = "smoldering"
	name = "Smoldering"
	appearance_rate = 0.15
	if burning_status == null:
		burning_status = BurningStatus.new()

func after_invoke(
	calling_spell: Spell,
	resolver: BattleResolver,
	_casters: Array[BattleParticipant], 
	targets: Array[BattleParticipant],
	_battle_context: BattleContext
) -> void:
	if burning_status == null:
		push_warning("SmolderingMutation: burning_status not set!")
		return
	
	# Apply burning to all targets
	for target in targets:
		resolver.apply_status(target, burning_status, 2)

func modify_description(spell_description: String) -> String:
	return spell_description + " [Smoldering: Applies 2 Burning]"
