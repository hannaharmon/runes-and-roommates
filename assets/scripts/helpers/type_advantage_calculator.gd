class_name TypeAdvantageCalculator
## Calculates damage multipliers based on elemental type advantages.
##
## Type advantages:
## - Fire > Earth
## - Water > Fire
## - Earth > Water
## - Dark > Light
## - Light > Dark
## - Machine and Beast are neutral (no advantages)

## Returns the total damage multiplier based on type advantages.
## 
## For each attacker element that has advantage over a defender element,
## multiplier increases by (attacker_ratio * defender_ratio).
## Example: 0.25 Water attacking 0.5 Fire = 1.0 + (0.25 * 0.5) = 1.125x damage
static func calculate_type_advantage_multiplier(
	attacker_ratio: ElementRatio,
	defender_ratio: ElementRatio
) -> float:
	if attacker_ratio == null or defender_ratio == null:
		return 1.0
	
	var multiplier := 1.0
	
	# Check each element in attacker's ratio
	for attacker_elem: Enums.Element in attacker_ratio.ratio:
		var attacker_amount: float = attacker_ratio.ratio[attacker_elem]
		
		# Check what this element has advantage over
		var advantage_against = _get_advantage_against(attacker_elem)
		if advantage_against == null:
			continue
		
		# If defender has the weak element, apply bonus
		if defender_ratio.ratio.has(advantage_against):
			var defender_amount: float = defender_ratio.ratio[advantage_against]
			multiplier += attacker_amount * defender_amount
	
	return multiplier

## Returns which element the given element has advantage over, or null if none.
static func _get_advantage_against(element: Enums.Element) -> Variant:
	match element:
		Enums.Element.FIRE:
			return Enums.Element.EARTH
		Enums.Element.WATER:
			return Enums.Element.FIRE
		Enums.Element.EARTH:
			return Enums.Element.WATER
		Enums.Element.DARK:
			return Enums.Element.LIGHT
		Enums.Element.LIGHT:
			return Enums.Element.DARK
		_:
			return null  # METAL and BEAST have no advantages
