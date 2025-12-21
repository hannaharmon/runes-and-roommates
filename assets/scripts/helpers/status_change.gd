class_name StatusChange
extends RefCounted
## Represents a status effect change on a battle participant.
##
## Used by SpellPreviewResult to track status applications and removals.
## Positive stacks = applied, negative stacks = removed.

var target: BattleParticipant
var status: StatusTemplateData
var stacks: int  # Positive for applied, negative for removed

func _init(
	status_target: BattleParticipant,
	status_template: StatusTemplateData,
	status_stacks: int
):
	target = status_target
	status = status_template
	stacks = status_stacks

## Returns true if this represents a status application (positive stacks).
func is_application() -> bool:
	return stacks > 0

## Returns true if this represents a status removal (negative stacks).
func is_removal() -> bool:
	return stacks < 0
