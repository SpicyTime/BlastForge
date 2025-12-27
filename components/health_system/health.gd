class_name Health
extends Node
@export var health: int = 10 : set = set_health
@export var max_health: int = 10 : set = set_max_health

func set_health(value: int) -> void:
	health = value


	SignalManager.health_changed.emit(abs(health - value))
	if health == 0:
		SignalManager.health_depleted.emit(self)


func set_max_health(value: int) -> void:
	max_health = value
	SignalManager.max_health_changed.emit(abs(max_health - value))
