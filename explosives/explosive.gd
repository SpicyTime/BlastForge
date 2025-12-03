class_name Explosive
extends Node2D
@export var keep_detection_active: bool = false
@export var detonation_time: float = 1.5
var phase_time: float = 0.0
var red_material: ShaderMaterial = preload("res://explosives/materials/red_circle_material.tres")
@onready var explosive_area_shader_box: Sprite2D = $ExplosiveAreaShaderBox
@onready var explosive_sprite: Sprite2D = $ExplosiveSprite
@onready var detonation_timer: Timer = $DetonationTimer
@onready var hitbox_collider: CollisionShape2D = $ExplosionArea/HitboxCollider
@onready var detection_area_collider: CollisionShape2D = $ExplosionDetectionArea/DetectionAreaCollider
@onready var explosion_detection_area: Area2D = $ExplosionDetectionArea
@onready var explosion_area: Hitbox = $ExplosionArea

func _process(delta: float) -> void:
	phase_time += delta
	if phase_time > 1.0:
		phase_time -= 1.0


func handle_placed() -> void:
	# TO DO: Play a placing sound
	detonation_timer.start(detonation_time)
	explosive_area_shader_box.material = red_material.duplicate()
	explosive_area_shader_box.material.set("shader_parameter/phase_offset", phase_time * TAU)
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


func spawn_floating_text(text: String, text_position: Vector2, text_color: Color, visible_time: float):
	var floating_text: Marker2D = load(Constants.FLOATING_TEXT_PATH).instantiate()
	var text_label: Label = floating_text.get_child(0)
	floating_text.exist_time = visible_time
	text_label.text = text
	floating_text.position = text_position
	text_label.add_theme_color_override("font_color", text_color)
	add_child(floating_text)
	await get_tree().create_timer(visible_time).timeout
	floating_text.queue_free()
