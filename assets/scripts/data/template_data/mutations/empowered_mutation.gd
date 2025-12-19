class_name EmpoweredMutation
extends MutationTemplateData
## Increases spell power by 50%.

const POWER_MULTIPLIER := 1.5

func modify_power(power: float) -> float:
	return power * POWER_MULTIPLIER

func modify_description(spell_description: String) -> String:
	return spell_description + " [Empowered: +50% damage]"
