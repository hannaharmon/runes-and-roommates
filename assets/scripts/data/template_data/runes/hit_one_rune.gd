class_name HitOneRune
extends RuneTemplateData
## Example rune that deals damage to a single target.
##
## This demonstrates the minimal implementation needed for a damage-dealing rune.

func invoke_rune(
	calling_spell: Spell,
	resolver: BattleResolver,
	_casters: Array[BattleParticipant], 
	targets: Array[BattleParticipant], 
	_context: BattleContext
) -> void:
	if targets.is_empty():
		return
	
	# Get the first target
	var target := targets[0]
	
	# Create an effect source for this spell
	var source := EffectSource.new(calling_spell)
	
	# Deal damage equal to the spell's power
	var damage := int(calling_spell.power)
	resolver.deal_damage(source, target, damage, [])
