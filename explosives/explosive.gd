class_name Explosive
extends Node2D
@export var keep_detection_active: bool = false
@export var detonation_time: float = 1.5
var phase_time: float = 0.0
var red_material: ShaderMaterial = preload("res://explosives/materials/red_circle_material.tres")
var is_up_pulse: bool = false
var pulse_time: float = 0.46
@onready var explosive_area_shader_box: Sprite2D = $ExplosiveAreaShaderBox
@onready var explosive_sprite: Sprite2D = $ExplosiveSprite
@onready var explosion_area_hitbox: Hitbox = $ExplosionAreaHitbox
@onready var hitbox_collider: CollisionShape2D = $ExplosionAreaHitbox/HitboxCollider
@onready var detection_area_collider: CollisionShape2D = $ExplosionDetectionArea/DetectionAreaCollider
@onready var explosion_detection_area: Area2D = $ExplosionDetectionArea
@onready var push_area_collider: CollisionShape2D = $ExplosionPushArea/PushAreaCollider
@onready var detonation_timer: Timer = $DetonationTimer

func _ready() -> void:
	var radius: float = StatManager.get_explosive_stat("explosion_radius")
	_set_radii(radius, radius * 0.64)


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
	var pulse_scale_tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	pulse_scale_tween.tween_property(explosive_sprite, "scale", Vector2(0.9, 0.9), pulse_time)
	pulse_scale_tween.finished.connect(_on_pulse_tween_finished)


func _set_radii(explosion_radius: float, shader_radius: float) -> void:
	hitbox_collider.shape.radius = explosion_radius
	detection_area_collider.shape.radius = explosion_radius
	# Sets the radius of both color materials
	explosive_area_shader_box.material.set("shader_parameter/radius", shader_radius)
	red_material.set("shader_parameter/radius", shader_radius)


func _on_detonation_timer_timeout() -> void:
	# TO DO: Handle all explosion effects, particles, sounds, etc...
	hitbox_collider.disabled = false
	push_area_collider.disabled = false
	var final_scale: Vector2 = Vector2(1.35, 1.35)
	var scale_up_explosion_tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	scale_up_explosion_tween.tween_property(explosive_sprite, "scale", final_scale, 0.11)
	var breakables_broken: Array[Node2D] = explosion_detection_area.get_overlapping_bodies()
	explosion_area_hitbox.damage = StatManager.get_explosive_stat("damage") as int
	await scale_up_explosion_tween.finished
	queue_free()
	SignalManager.explosive_detonated.emit(breakables_broken)


func _on_pulse_tween_finished() -> void:
	var pulse_scale: Vector2 = Vector2.ZERO
	if is_up_pulse:
		is_up_pulse = false
		pulse_scale = Vector2(0.95, 0.95)
	else:
		is_up_pulse = true
		pulse_scale = Vector2(1.05, 1.05)
	var pulse_scale_tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	pulse_scale_tween.tween_property(explosive_sprite, "scale", pulse_scale, pulse_time)
	pulse_scale_tween.finished.connect(_on_pulse_tween_finished)


func _on_explosion_push_area_body_entered(body: Node2D) -> void:
	if body is Breakable and not body in explosion_area_hitbox.get_overlapping_bodies():
		body = body as Breakable
		body.move_direction = position.direction_to(body.position)
		var push_force: float = 8.75
		body.speed = body.base_speed * push_force
