class_name CharacterBattleParticipant 
extends BattleParticipant

var character_template: CharacterTemplateData
var saved_character_data: CharacterSaveData

func _init(template: CharacterTemplateData, save_data: CharacterSaveData, ally: bool = true):
	character_template = template
	saved_character_data = save_data
	is_ally = ally
	max_health = template.base_health
	current_health = max_health
	element_ratio = template.element_ratio
	statuses = {}

func get_template() -> CreatureTemplateData:
	return character_template
