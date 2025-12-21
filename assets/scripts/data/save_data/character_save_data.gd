class_name CharacterSaveData
extends Resource

@export var id: String
@export var level: int
@export var relationship_level: int
@export var discovered: bool

func _init(
	character_id: String = "",
	character_level: int = 1,
	character_relationship_level: int = 0,
	character_discovered: bool = false
):
	id = character_id
	level = character_level
	relationship_level = character_relationship_level
	discovered = character_discovered
