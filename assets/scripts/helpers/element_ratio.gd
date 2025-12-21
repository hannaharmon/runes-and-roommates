@tool
class_name ElementRatio 
extends Resource

@export var ratio: Dictionary[Enums.Element, float] = {}:
	set(value):
		ratio = value
		if Engine.is_editor_hint():
			_validate()

func _init():
	_validate()

func _validate() -> bool:
	if not Engine.is_editor_hint():
		return true
	if ratio == null or ratio.is_empty():
		push_warning("ElementRatio has no elements configured. Add at least one element.")
		print_rich("[color=yellow]⚠ ElementRatio has no elements configured. Add at least one element.[/color]")
		return false
	
	var sum := 0.0
	for element_value in ratio.values():
		sum += element_value
	const EPSILON := 0.0001
	if abs(sum - 1.0) > EPSILON:
		var msg := "ElementRatio has ratios that sum to " + str(sum) + " instead of 1.0."
		push_warning(msg)
		print_rich("[color=yellow]⚠ " + msg + "[/color]")
		return false
	
	return true
