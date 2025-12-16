class_name Upgrade
extends RefCounted
var data: UpgradeData
var current_tier: int = 0

func can_upgrade() -> bool:
	return current_tier < data.values.size() 


func get_upgraded_stat(base_value) -> float:
	match data.affector_type:
		Enums.AffectorType.ADDITIVE:
			return base_value + data.values[current_tier]
		Enums.AffectorType.SUBTRACTIVE:
			return base_value - data.values[current_tier]
		Enums.AffectorType.MULTIPLICATIVE:
			return base_value * data.values[current_tier]
		Enums.AffectorType.DIVISITIVE: 
			return base_value / data.values[current_tier]
		_:
			return base_value
