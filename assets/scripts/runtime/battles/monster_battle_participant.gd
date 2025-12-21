class_name MonsterBattleParticipant 
extends BattleParticipant

var template: MonsterTemplateData

func _init(monster_template: MonsterTemplateData, ally: bool = false):
	template = monster_template
	is_ally = ally
	element_ratio = monster_template.element_ratio
	max_health = monster_template.base_health
	current_health = max_health
	statuses = {}
