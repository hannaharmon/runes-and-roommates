class_name DescriptionFormatter
## Turns raw descriptions into BBCode for use by RichTextLabels.

static func format(text: String) -> String:
	var result := text
	result = _format_statuses(result)
	result = _format_keywords(result)
	result = _format_numbers(result)
	return result

static func _format_statuses(text: String) -> String:
	return text
	
static func _format_keywords(text: String) -> String:
	return text
	
static func _format_numbers(text: String) -> String:
	return text
