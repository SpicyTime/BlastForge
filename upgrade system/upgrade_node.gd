class_name UpgradeNode
extends Control
@export var data: UpgradeData 
@export var price: int = 0
var upgrade: Upgrade = null

func _ready() -> void:
	if data:
		upgrade = Upgrade.new()
		upgrade.data = data
