class_name SpellPreviewResult
extends RefCounted
## Condenses the information returned by Spell's preview method.
##
## This information is everything we need for UI representation 
## of a spell preview.

var damage_by_target: Dictionary[BattleParticipant, int]
var heal_by_target: Dictionary[BattleParticipant, int]
var statuses_applied: Dictionary[BattleParticipant, int]

func _init():
    damage_by_target = {}
    heal_by_target = {}
    statuses_applied = {}