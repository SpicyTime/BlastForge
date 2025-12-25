class_name UpgradeData
extends Resource

@export var tier_modifiers: Array[float] = []
@export var tier_prices: Array[int] = []
@export var tier_names: Array[String] = []
@export var description: String = ""
@export var modify_stat_name: String = ""
@export var operation_type: Enums.OperationType = Enums.OperationType.ADDITIVE
