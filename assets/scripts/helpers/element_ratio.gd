@tool
class_name ElementRatio 
extends Resource

@export var ratio: Dictionary[Enums.Element, float] = {}:
	set(value):
		ratio = value
		if Engine.is_editor_hint():
			_validate()

func _init():
	if not changed.is_connected(_on_editor_change):
		changed.connect(_on_editor_change)
	_validate()

func _on_editor_change():
	if Engine.is_editor_hint():
		_validate()

func _validate() -> bool:
	if not Engine.is_editor_hint():
		return true
	var label := TemplateValidation._describe(self)
	if ratio == null or ratio.is_empty():
		var msg := label + " has no elements configured. Add at least one element."
		push_warning(msg)
		print_rich("[color=yellow]⚠ " + msg + "[/color]")
		return false
	var sum := 0.0
	for element_value in ratio.values():
		sum += element_value
	const EPSILON := 0.0001
	if abs(sum - 1.0) > EPSILON:
		var msg := label + " has ratios that sum to " + str(sum) + " instead of 1.0."
		push_warning(msg)
		print_rich("[color=yellow]⚠ " + msg + "[/color]")
		return false
	return true
