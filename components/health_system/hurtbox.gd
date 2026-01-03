class_name Hurtbox
extends Area2D
@export var health_node: Health = null

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox and area.get_parent() != get_parent():
		var hitbox: Hitbox = area as Hitbox
		health_node.set_health(health_node.health - hitbox.damage)
		SignalManager.damage_taken.emit(hitbox.damage)
		
