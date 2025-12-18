class_name GameSaveData
extends Resource

@export var unlocked_rune_ids: Array[String] = []
@export var owned_spells: Array[SpellSaveData] = []
@export var deck_spell_indices: Array[int] = []
@export var discovered_monsters: Array[MonsterSaveData] = []
@export var discovered_items: Array[ItemSaveData] = []
@export var characters_state: Array[CharacterSaveData] = []
