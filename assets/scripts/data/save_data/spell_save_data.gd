class_name SpellSaveData
extends Resource

@export var name: String
@export var ink: InkTemplateData
@export var rune: RuneTemplateData
@export var mutations: Array[MutationTemplateData]

func _init(
	spell_name: String = "",
	spell_ink: InkTemplateData = null,
	spell_rune: RuneTemplateData = null,
	spell_mutations: Array[MutationTemplateData] = []
):
	name = spell_name
	ink = spell_ink
	rune = spell_rune
	mutations = spell_mutations
