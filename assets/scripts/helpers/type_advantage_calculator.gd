class_name TypeAdvantageCalculator
## Calculates damage multipliers based on elemental type advantages.
##
## IMPORTANT: Type advantages are based on the DAMAGE SOURCE's element_ratio vs the 
## TARGET's element_ratio. This applies to spells, status effects, or any other 
## damage source. element_ratio of caster(s) is NOT used for type advantage calculations.
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
## For each element in the damage source that has advantage over an element in the target,
## multiplier increases by (damage_ratio * target_ratio).
## Example: 0.25 Water damage hitting 0.5 Fire target = 1.0 + (0.25 * 0.5) = 1.125x damage
##
## @param damage_ratio: The element ratio of the damage source (spell, status, etc.)
## @param target_ratio: The element ratio of the target receiving damage
static func calculate_type_advantage_multiplier(
	damage_ratio: ElementRatio,
	target_ratio: ElementRatio
) -> float:
	if damage_ratio == null or target_ratio == null:
		return 1.0
	
	var multiplier := 1.0
	
	# Check each element in the damage source's ratio
	for damage_elem: Enums.Element in damage_ratio.ratio:
		var damage_amount: float = damage_ratio.ratio[damage_elem]
		
		# Check what this element has advantage over
		var advantage_against = _get_advantage_against(damage_elem)
		if advantage_against == null:
			continue
		
		# If target has the weak element, apply bonus
		if target_ratio.ratio.has(advantage_against):
			var target_amount: float = target_ratio.ratio[advantage_against]
			multiplier += damage_amount * target_amount
	
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
