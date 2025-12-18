class_name ElementCalculator
## Helper class for calculating element points.
##
## For power levels that do not break down nicely with the given ratios,
## we distribute the remainder in a way that favors higher ratio elements
## and uses the ordering of the ElementRatio passed in as the tiebreaker.

static func calculate_points(
	power: float, 
	element_ratio: ElementRatio
) -> ElementPoints:
	var points: Dictionary[Enums.Element, int] = {}
	var total_floored_points := 0
	
	for e: Enums.Element in element_ratio.ratio:
		var calculated_points = power * element_ratio.ratio[e]
		points[e] = floor(calculated_points)
		total_floored_points += floor(calculated_points)
	
	var remaining = power - total_floored_points
	if remaining == 0:
		return ElementPoints.new(points)
	
	var elems_sorted_by_ratio: Array[Enums.Element] = _sort_dict_by_value(element_ratio.ratio).keys
	for i in range(remaining):
		points[elems_sorted_by_ratio[i]] += 1
		
	return ElementPoints.new(points)
	
static func _sort_dict_by_value(input_dict: Dictionary) -> Dictionary:
	# 1. Convert dictionary items to an array of [key, value] pairs.
	#    The .keys() method returns an array of keys. We can map those
	#    to an array of [key, value] pairs.
	var pairs = input_dict.keys().map(func(key): return [key, input_dict[key]])

	# Sort the array of pairs in place.
	pairs.sort_custom(_sort_by_second_element)

	# Create a new dictionary and re-insert elements in the sorted order.
	var sorted_dict := {}
	for p in pairs:
		sorted_dict[p[0]] = p[1]
		
	return sorted_dict

# A custom sorting function to compare the second element (the value) of the pairs
static func _sort_by_second_element(a, b):
	# This function should return true if 'a' should come before 'b'
	return a[1] > b[1] || a[1] == b[1] and a[0] <= b[0]
