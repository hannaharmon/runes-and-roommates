@abstract 
class_name CharacterBattleParticipant 
extends BattleParticipant

var character_template: CharacterTemplateData
var saved_character_data: CharacterSaveData

func _init(template: CharacterTemplateData, save_data: CharacterSaveData):
	character_template = template
	saved_character_data = save_data
	max_health = template.base_health
	current_health = max_health
	element_ratio = template.element_ratio
