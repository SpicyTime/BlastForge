class_name UpgradeData
extends Node
enum AffectorType{
	ADDITIVE,
	SUBTRACTIVE, 
	MULTIPLICATIVE,
	DIVISITIVE
}
@export var upgrade_name: String = ""
@export var description: String = ""
@export var affector_type: AffectorType = AffectorType.ADDITIVE
@export var amount: float = 0.0

func apply_upgrade_to_stat(base_value: float) -> float:
	match affector_type:
		AffectorType.ADDITIVE:
			return base_value + amount
		AffectorType.SUBTRACTIVE:
			return base_value - amount
		AffectorType.MULTIPLICATIVE:
			return base_value * amount
		AffectorType.DIVISITIVE: 
			return base_value / amount
		_:
			return base_value
