class_name ElementPoints 
extends RefCounted

var points: Dictionary[Enums.Element, int]

func _init(element_points: Dictionary[Enums.Element, int]):
	points = element_points
