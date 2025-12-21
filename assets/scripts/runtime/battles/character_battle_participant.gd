class_name CharacterBattleParticipant 
extends BattleParticipant

var save_data: CharacterSaveData

func _init(character_template: CharacterTemplateData, character_save_data: CharacterSaveData, ally: bool = true):
	template = character_template
	save_data = character_save_data
	level = character_save_data.level
	is_ally = ally
	max_health = _calc_max_health()
	current_health = max_health
	element_ratio = template.element_ratio
	statuses = {}