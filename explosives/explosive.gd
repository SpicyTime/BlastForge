class_name Explosive
extends Node2D
@onready var explosive_area_shader_box: Sprite2D = $ExplosiveAreaShaderBox
@onready var explosive_sprite: Sprite2D = $ExplosiveSprite
@onready var detonation_timer: Timer = $DetonationTimer
@onready var hitbox_collider: CollisionShape2D = $ExplosionArea/HitboxCollider
var detonation_time: float = 1.15


func handle_placed() -> void:
	# TO DO: Play a placing sound
	explosive_area_shader_box.visible = false
	explosive_sprite.z_index = 0
	detonation_timer.start(detonation_time)


func _on_detonation_timer_timeout() -> void:
	# TO DO: Handle all explosion effects, particles, sounds, etc...
	hitbox_collider.disabled = false
	# A short delay to allow for collision detection with the other areas
	for i in range(3):
		await get_tree().process_frame
	
	queue_free()
