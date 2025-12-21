class_name MonsterBattleParticipant 
extends BattleParticipant

func _init(monster_template: MonsterTemplateData, ally: bool = false, monster_level: int = 1):
	template = monster_template
	is_ally = ally
	level = monster_level
	element_ratio = monster_template.element_ratio
	max_health = _calc_max_health()
	current_health = max_health
	statuses = {}