@abstract
class_name BattleParticipant
extends RefCounted

var template: CreatureTemplateData
var level: int
var is_ally: bool
var max_health: int
var current_health: int
var element_ratio: ElementRatio
var statuses: Dictionary[StatusTemplateData, int]

func is_dizzy() -> bool:
	return false

func get_element_ratio() -> ElementRatio:
	return element_ratio

func _calc_max_health() -> int:
	return template.base_health + template.health_incr_per_level * (level - 1)
