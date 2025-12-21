@tool
class_name TemplateData 
extends Resource

@export var id: String = "":
	set(value):
		id = value
		if Engine.is_editor_hint():
			_validate()

@export var name: String = "":
	set(value):
		name = value
		if Engine.is_editor_hint():
			_validate()

@export var description: String:
	set(value):
		description = value

func _init():
	_validate()

func _validate() -> bool:
	if not Engine.is_editor_hint():
		return true
	var valid := true
	if id.is_empty():
		var msg := TemplateValidation._describe(self) + " is missing required field 'id'."
		push_warning(msg)
		print_rich("[color=yellow]⚠ " + msg + "[/color]")
		valid = false
	if name.is_empty():
		var msg := TemplateValidation._describe(self) + " is missing required field 'name'."
		push_warning(msg)
		print_rich("[color=yellow]⚠ " + msg + "[/color]")
		valid = false
	return valid
