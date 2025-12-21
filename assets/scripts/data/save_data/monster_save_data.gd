class_name MonsterSaveData
extends Resource

@export var id: String
@export var level: int
@export var killed_count: int
@export var discovered: bool

func _init(
	monster_id: String = "",
	monster_killed_count: int = 0,
	monster_discovered: bool = false
):
	id = monster_id
	killed_count = monster_killed_count
	discovered = monster_discovered