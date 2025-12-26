class_name UpgradeData
extends Resource

@export var base_value: float = 0.0
@export var tier_modifiers: Array[float] = []
@export var tier_prices: Array[int] = []
@export var tier_names: Array[String] = []
@export var description: String = ""
@export var modify_stat_name: String = ""
@export var extra_character: String = ""
@export var operation_type: Enums.OperationType = Enums.OperationType.ADDITIVE
