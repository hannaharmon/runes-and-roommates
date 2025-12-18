class_name SpellPreviewResult
## Condenses the information reuturned by Spell's preview method.
##
## This information is everything we need for UI representation 
## of a spell preivew.

var damage_by_target: Dictionary[BattleParticipant, int]
var heal_by_target: Dictionary[BattleParticipant, int]
var statuses_applied: Dictionary[BattleParticipant, int]
