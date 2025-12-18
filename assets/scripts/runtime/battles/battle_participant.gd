class_name BattleParticipant

var is_ally: bool
var current_health: int
var statuses: Dictionary[StatusTemplateData, int]

func is_dizzy() -> bool:
	return false
