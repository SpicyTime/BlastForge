class_name Hurtbox
extends Area2D
@export var health_node: Health = null

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var hitbox: Hitbox = area as Hitbox
		health_node.set_health(hitbox.damage)
		SignalManager.damage_taken.emit(hitbox.damage)
