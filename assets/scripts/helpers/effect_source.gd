class_name EffectSource
extends RefCounted
## Tracks the source of a damage/heal/status effect for proper attribution.
##
## Used by resolvers to determine element ratio for type advantages and
## to apply source-specific modifiers.

var spell: Spell = null
var status: StatusTemplateData = null
var mutation: MutationTemplateData = null
var element_ratio: ElementRatio = null

func _init(
	from_spell: Spell = null,
	from_status: StatusTemplateData = null,
	from_mutation: MutationTemplateData = null,
	from_element_ratio: ElementRatio = null
):
	spell = from_spell
	status = from_status
	mutation = from_mutation
	
	# Automatically unpack element_ratio from spell or status
	if from_spell != null:
		element_ratio = from_spell.element_ratio
	elif from_status != null and from_status.element_ratio != null:
		element_ratio = from_status.element_ratio
	elif from_element_ratio != null:
		element_ratio = from_element_ratio