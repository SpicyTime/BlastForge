class_name Explosive
extends Node2D
@export var keep_detection_active: bool = false
var detonation_time: float = 1.15
@onready var explosive_area_shader_box: Sprite2D = $ExplosiveAreaShaderBox
@onready var explosive_sprite: Sprite2D = $ExplosiveSprite
@onready var detonation_timer: Timer = $DetonationTimer
@onready var hitbox_collider: CollisionShape2D = $ExplosionArea/HitboxCollider
@onready var detection_area_collider: CollisionShape2D = $ExplosionDetectionArea/DetectionAreaCollider
@onready var explosion_detection_area: Area2D = $ExplosionDetectionArea
@onready var explosion_area: Hitbox = $ExplosionArea



func handle_placed() -> void:
	# TO DO: Play a placing sound
	explosive_area_shader_box.visible = false
	explosive_sprite.z_index = 1
	detonation_timer.start(detonation_time)
	if not keep_detection_active:
		explosion_detection_area.monitorable = false
		explosion_detection_area.monitoring = false


func _on_detonation_timer_timeout() -> void:
	# TO DO: Handle all explosion effects, particles, sounds, etc...
	hitbox_collider.disabled = false
	# A short delay to allow for collision detection with the other areas
	await get_tree().process_frame
	await get_tree().process_frame
	call_deferred("queue_free")
