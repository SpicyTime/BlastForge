class_name Upgrade
extends RefCounted
var data: UpgradeData
var current_tier: int = 0


func has_reached_max_tier() -> bool:
	return current_tier < data.tier_modifiers.size() 


func get_price() -> int:
	return data.tier_prices[current_tier]


func get_name() -> String:
	return data.tier_names[current_tier]


func get_upgraded_stat(base_value) -> float:
	match data.operation_type:
		Enums.OperationType.ADDITIVE:
			return base_value + data.tier_modifiers[current_tier]
		Enums.OperationType.SUBTRACTIVE:
			return base_value - data.tier_modifiers[current_tier]
		Enums.OperationType.MULTIPLICATIVE:
			return base_value * data.tier_modifiers[current_tier]
		Enums.OperationType.DIVISITIVE: 
			return base_value / data.tier_modifiers[current_tier]
		_:
			return base_value
