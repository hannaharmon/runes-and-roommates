class_name SteamyMutation
extends MutationTemplateData
## Applies 1 stack of Sleep status to the target after the spell resolves.

# TODO: Create and reference the actual Sleep status template
# For now, this is a placeholder showing the pattern
var sleep_status: StatusTemplateData  # Should be set in the editor or loaded

func after_invoke(
	calling_spell: Spell,
	resolver: BattleResolver,
	_casters: Array[BattleParticipant], 
	targets: Array[BattleParticipant],
	_battle_context: BattleContext
) -> void:
	if sleep_status == null:
		push_warning("SteamyMutation: sleep_status not set!")
		return
	
	# Apply sleep to all targets
	for target in targets:
		resolver.apply_status(target, sleep_status, 1)

func modify_description(spell_description: String) -> String:
	return spell_description + " [Steamy: Applies 1 Sleep]"
