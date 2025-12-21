class_name TemplateValidation
extends RefCounted
## Utility for validating template/save resources at runtime.
##
## Templates now validate themselves, but this utility is still useful for:
## - Complex cross-resource validation (e.g., spell compilation checks)
## - Runtime-only validation scenarios
## - Consistent error message formatting

static func _describe(owner: Resource) -> String:
	if owner == null:
		return "<unknown resource>"
	var label := owner.resource_path
	if label == "":
		label = owner.resource_name
	var type_name := owner.get_class()
	if label == "":
		return type_name + "@" + str(owner.get_instance_id())
	return label + " (" + type_name + ")"

static func require_resource(value, owner: Resource, field_name: String) -> bool:
	if value != null:
		return true
	var msg := _describe(owner) + " is missing required field '" + field_name + "'."
	if Engine.is_editor_hint():
		push_warning(msg)
		print_rich("[color=yellow]⚠ " + msg + "[/color]")
	else:
		push_error(msg)
	return false

static func require_ratio(ratio: ElementRatio, owner: Resource, field_name: String, check_normalized: bool = true) -> bool:
	if not require_resource(ratio, owner, field_name):
		return false
	if ratio.resource_name == "":
		var owner_label := _describe(owner)
		ratio.resource_name = owner_label + "::" + field_name
	if ratio.ratio == null or ratio.ratio.is_empty():
		var msg := _describe(owner) + " has '" + field_name + "' assigned but no elements configured."
		if Engine.is_editor_hint():
			push_warning(msg)
			print_rich("[color=yellow]⚠ " + msg + "[/color]")
		else:
			push_error(msg)
		return false
	
	if check_normalized:
		var sum := 0.0
		for value in ratio.ratio.values():
			sum += value
		const EPSILON := 0.0001
		if abs(sum - 1.0) > EPSILON:
			var msg := _describe(owner) + " has '" + field_name + "' with ratios that sum to " + str(sum) + " instead of 1.0."
			if Engine.is_editor_hint():
				push_warning(msg)
				print_rich("[color=yellow]⚠ " + msg + "[/color]")
			else:
				push_error(msg)
			return false
	
	return true
