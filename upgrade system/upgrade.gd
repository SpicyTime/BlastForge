class_name Upgrade
extends RefCounted
var data: UpgradeData
var current_unpurchased_tier: int = 1
var current_purchased_tier: int = 0
const PRICE_SCALE: float = 2.2
func has_reached_max_tier() -> bool:
	return current_purchased_tier >= data.tier_modifiers.size() 
 

func get_before_after() -> String:
	if has_reached_max_tier():
		return str(data.tier_modifiers[current_purchased_tier - 1]) + data.extra_character
	var first_value: String = ""
	var arrow: String = " -> "
	var second_value: String = ""
	# Modifies it to show the final value
	if data.operation_type == Enums.OperationType.ADDITIVE:
		second_value = str(data.tier_modifiers[current_unpurchased_tier - 1] + data.base_value)
	elif data.operation_type == Enums.OperationType.SUBTRACTIVE:
		second_value = str(data.tier_modifiers[current_unpurchased_tier - 1] - data.base_value)
	else:
		second_value = str(data.tier_modifiers[current_unpurchased_tier - 1])
	
	if current_purchased_tier == 0:
		first_value = str(data.base_value)
	else:
		first_value = str(data.tier_modifiers[current_purchased_tier - 1])
	return first_value + data.extra_character + arrow + second_value + data.extra_character



func get_current_price() -> int:
	return _calculate_price(data.base_price, current_unpurchased_tier, data.price_scale)


func get_previous_price() -> int:
	return _calculate_price(data.base_price, current_purchased_tier, data.price_scale)


func get_name() -> String:
	return data.name


func get_upgraded_stat(base_value) -> float:
	var current_tier_index: int = current_purchased_tier - 1
	match data.operation_type:
		Enums.OperationType.ADDITIVE:
			return base_value + data.tier_modifiers[current_tier_index]
		Enums.OperationType.SUBTRACTIVE:
			return base_value - data.tier_modifiers[current_tier_index]
		Enums.OperationType.MULTIPLICATIVE:
			return base_value * data.tier_modifiers[current_tier_index]
		Enums.OperationType.DIVISITIVE: 
			return base_value / data.tier_modifiers[current_tier_index]
		Enums.OperationType.SET:
			return data.tier_modifiers[current_tier_index]
		_:
			return base_value

func _calculate_price(base_value: int, n: int, price_scale: float) -> int:
	return int(base_value + (n - 1) * (base_value * price_scale))
