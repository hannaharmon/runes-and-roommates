class_name SpellPreviewResult
extends RefCounted
## Condenses the information returned by Spell's preview method.
##
## This information is everything we need for UI representation 
## of a spell preview.

var damage_by_target: Dictionary[BattleParticipant, int]
var heal_by_target: Dictionary[BattleParticipant, int]
var status_changes: Array[StatusChange]  # All status applications/removals

func _init():
	damage_by_target = {}
	heal_by_target = {}
	status_changes = []

## Get all status changes for a specific target.
func get_status_changes_for_target(target: BattleParticipant) -> Array[StatusChange]:
	var result: Array[StatusChange] = []
	for change in status_changes:
		if change.target == target:
			result.append(change)
	return result

## Get the net stack change for a specific status on a specific target.
## Combines all applications and removals.
func get_net_stacks(target: BattleParticipant, status: StatusTemplateData) -> int:
	var net := 0
	for change in status_changes:
		if change.target == target and change.status == status:
			net += change.stacks
	return net
