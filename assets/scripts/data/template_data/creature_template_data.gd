@tool
@abstract 
class_name CreatureTemplateData 
extends TemplateData

@export var element_ratio: ElementRatio:
	set(value):
		element_ratio = value
		if Engine.is_editor_hint():
			_validate()

@export var base_health: int:
	set(value):
		base_health = value
		if Engine.is_editor_hint():
			_validate()

func _init():
	super._init()
	_validate()

func _validate() -> bool:
	if not Engine.is_editor_hint():
		return true
	if resource_path == "" and resource_name == "":
		return true
	var valid := super._validate()
	if not TemplateValidation.require_ratio(element_ratio, self, "element_ratio"):
		valid = false
	if base_health <= 0:
		var msg := TemplateValidation._describe(self) + " has invalid base_health (" + str(base_health) + "). Must be > 0."
		push_warning(msg)
		print_rich("[color=yellow]⚠ " + msg + "[/color]")
		valid = false
	return valid
