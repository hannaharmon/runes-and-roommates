@tool
class_name InkTemplateData 
extends TemplateData

@export var texture: Texture2D

@export var element_ratio: ElementRatio:
	set(value):
		element_ratio = value
		if Engine.is_editor_hint():
			_validate()

@export var power: int:
	set(value):
		power = value
		if Engine.is_editor_hint():
			_validate()

func _init():
	super._init()
	_validate()

func _validate() -> bool:
	if not Engine.is_editor_hint():
		return true
	var valid := super._validate()
	if not TemplateValidation.require_ratio(element_ratio, self, "element_ratio"):
		valid = false
	if power <= 0:
		var msg := TemplateValidation._describe(self) + " has invalid power (" + str(power) + "). Must be > 0."
		push_warning(msg)
		print_rich("[color=yellow]⚠ " + msg + "[/color]")
		valid = false
	return valid
