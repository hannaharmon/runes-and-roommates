class_name MonsterBattleParticipant 
extends BattleParticipant

var template: MonsterTemplateData

func _init(monster_template: MonsterTemplateData):
	template = monster_template
	element_ratio = monster_template.element_ratio
	max_health = template.base_health
	current_health = max_health
