class_name BattleParticipant
extends RefCounted

var is_ally: bool
var max_health: int
var current_health: int
var element_ratio: ElementRatio
var statuses: Dictionary[StatusTemplateData, int]

func is_dizzy() -> bool:
	return false

func get_element_ratio() -> ElementRatio:
	return element_ratio
