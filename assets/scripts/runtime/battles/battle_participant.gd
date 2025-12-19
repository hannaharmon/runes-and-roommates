class_name BattleParticipant
extends RefCounted

var is_ally: bool
var current_health: int
var statuses: Dictionary[StatusTemplateData, int]

func is_dizzy() -> bool:
	return false
