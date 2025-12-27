class_name Explosive
extends Node2D
@export var keep_detection_active: bool = false
@export var detonation_time: float = 1.5
var phase_time: float = 0.0
var is_up_pulse: bool = false
var pulse_time: float = 0.46
const RED_CIRCLE_TEXTURE = preload("uid://dkiuwqe4ix6im")
@onready var explosive_sprite: Sprite2D = $ExplosiveSprite
@onready var explosion_area_sprite: Sprite2D = $ExplosionAreaSprite
@onready var explosion_area_hitbox: Hitbox = $ExplosionAreaHitbox
@onready var hitbox_collider: CollisionShape2D = $ExplosionAreaHitbox/HitboxCollider
@onready var detection_area_collider: CollisionShape2D = $ExplosionDetectionArea/DetectionAreaCollider
@onready var explosion_detection_area: Area2D = $ExplosionDetectionArea
@onready var push_area_collider: CollisionShape2D = $ExplosionPushArea/PushAreaCollider
@onready var detonation_timer: Timer = $DetonationTimer

func _ready() -> void:
	var radius: float = StatManager.get_explosive_stat("explosion_radius")
	_set_radii(radius)


func _process(delta: float) -> void:
	phase_time += delta
	if phase_time > 1.0:
		phase_time -= 1.0


func handle_placed() -> void:
	# TO DO: Play a placing sound
	detonation_timer.start(detonation_time)

	if not keep_detection_active:
		explosion_detection_area.monitorable = false
		explosion_detection_area.monitoring = false
		
	explosion_area_sprite.texture = RED_CIRCLE_TEXTURE
	_start_pulse(Vector2(0.9, 0.9), 0.47)


func _set_radii(explosion_radius: float) -> void:
	var scale_factor: float = explosion_radius / StatManager.explosive_stats["explosion_radius"] 
	explosion_area_sprite.scale = Vector2(scale_factor, scale_factor)
	hitbox_collider.shape.radius = explosion_radius
	detection_area_collider.shape.radius = explosion_radius


func _on_detonation_timer_timeout() -> void:
	# TO DO: Handle all explosion effects, particles, sounds, etc...
	hitbox_collider.disabled = false
	push_area_collider.disabled = false
	var final_scale: Vector2 = Vector2(1.35, 1.35)
	var scale_up_explosion_tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	scale_up_explosion_tween.tween_property(explosive_sprite, "scale", final_scale, 0.11)
	var alpha_explosion_tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	alpha_explosion_tween.tween_property(explosion_area_sprite, "self_modulate:a", 0.68, 0.11)
	var shapes_inside_range: Array[Node2D] = explosion_detection_area.get_overlapping_bodies()
	explosion_area_hitbox.damage = StatManager.get_explosive_stat("damage") as int
	await scale_up_explosion_tween.finished
	queue_free()
	var shapes_broken: Array[Node2D] = []
	for shape in shapes_inside_range:
		if shape is Shape:
			if shape.health.health <= 0:
				shapes_broken.append(shape)
	SignalManager.explosive_detonated.emit(shapes_broken)


func _start_pulse(scale_value: Vector2, alpha_value: float) -> void:
	var pulse_tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	pulse_tween.parallel().tween_property(
		explosion_area_sprite,
		"self_modulate:a",
		alpha_value,
		pulse_time
	)

	pulse_tween.parallel().tween_property(
		explosive_sprite,
		"scale",
		scale_value,
		pulse_time 
	)
	pulse_tween.finished.connect(_on_pulse_tween_finished)

	
func _on_pulse_tween_finished() -> void:
	var pulse_scale: Vector2 = Vector2.ZERO
	var pulse_alpha: float = 0.0
	if is_up_pulse:
		is_up_pulse = false
		pulse_scale = Vector2(0.95, 0.95)
		pulse_alpha = 0.49
	else:
		is_up_pulse = true
		pulse_scale = Vector2(1.05, 1.05)
		pulse_alpha = 0.68
	_start_pulse(pulse_scale, pulse_alpha)
	


func _on_explosion_push_area_body_entered(body: Node2D) -> void:
	if body is Shape:
		if not body in explosion_area_hitbox.get_overlapping_bodies() or body.health.health > 0:
			body = body as Shape
			body.move_direction = position.direction_to(body.position)
			var push_force: float = 8.75
			body.speed = body.base_speed * push_force
