class_name Shape
extends CharacterBody2D

var base_modulate: Color = modulate
var explosion_detected_modulate: Color = Color(0.5, 0.5, 0.5)
var type: Enums.BreakBehavior = Enums.BreakBehavior.NORMAL
var is_scaled: bool = false
var move_direction: Vector2 = Vector2(1, 1)
var speed: float = 0.0
var base_speed: float = 0.0
var prev_pos: Vector2 = Vector2.ZERO
var shape_data: ShapeData = null
var size_scales: Dictionary[Enums.ShapeSize, float] = {
	Enums.ShapeSize.SMALL : 1.0,
	Enums.ShapeSize.MEDIUM : 1.15,
	Enums.ShapeSize.LARGE :  1.35
}
const OFFSCREEN_PADDING: int = 20
const FRICTION: int = 11500
@onready var shape_sprite: Sprite2D = $ShapeSprite
@onready var shadow_sprite: Sprite2D = $ShadowSprite

@onready var hurtbox_collider: CollisionShape2D = $Hurtbox/HurtboxCollider
@onready var detector_collider: CollisionShape2D = $ExplosionDetector/DetectorCollider
@onready var shape_collider: CollisionShape2D = $ShapeCollider

@onready var health: Health = $Health

func _ready() -> void:
	SignalManager.health_changed.connect(_on_health_changed)
	prev_pos = position
	_set_up_colliders()
	_set_up_health()
	shape_sprite.texture = shape_data.shape_texture
	shadow_sprite.scale = Vector2.ZERO
	shape_sprite.scale = Vector2.ZERO
	var final_scale: Vector2 = Vector2(size_scales[shape_data.shape_size], size_scales[shape_data.shape_size])
	var scale_up_tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	var scale_up_time: float = 0.2
	scale_up_tween.tween_property(shape_sprite, "scale", final_scale, scale_up_time)
	scale_up_tween.parallel().tween_property(shadow_sprite, "scale", final_scale, scale_up_time)
	# This will make it feel a little nicer
	await get_tree().create_timer(scale_up_time / 2).timeout
	hurtbox_collider.disabled = false


func _physics_process(delta: float) -> void:
	if speed > base_speed:
		speed = move_toward(speed, base_speed, delta * FRICTION)
	velocity = speed * move_direction * delta
	_check_wall_rays()
	move_and_slide()


func handle_despawn() -> void:
	var scale_down_tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	var scale_down_time: float = 0.3
	scale_down_tween.tween_property(shape_sprite, "scale", Vector2.ZERO, scale_down_time)
	# Allows it to still be blown up for a bit
	await get_tree().create_timer(scale_down_time * 0.75).timeout
	if is_instance_valid(self): # Checks if the shape has been destroyed
		hurtbox_collider.disabled = true
		await scale_down_tween.finished # Checks if the shape has been destroyed
		queue_free()

func _is_offscreen(check_position: Vector2) -> bool:
	# Handles horizontal axis
	@warning_ignore("integer_division")
	if check_position.x > (Constants.VIEWPORT_WIDTH / 2) + OFFSCREEN_PADDING or check_position.x < -(Constants.VIEWPORT_WIDTH / 2) - OFFSCREEN_PADDING:
		return true
	
	@warning_ignore("integer_division")
	if check_position.y > (Constants.VIEWPORT_HEIGHT / 2) + OFFSCREEN_PADDING or check_position.y < -(Constants.VIEWPORT_HEIGHT / 2) - OFFSCREEN_PADDING:
		return true
	return false


func _set_up_colliders() -> void:
	# Sets Colliders
	var collision_shape: Shape2D = shape_data.shape_collider
	hurtbox_collider.set_deferred("shape", collision_shape)
	detector_collider.set_deferred("shape", collision_shape)
	shape_collider.set_deferred("shape", collision_shape)


func _set_up_health() -> void:
	var health_amount = StatManager.get_shape_health(shape_data.shape_type)
	health.set_max_health(health_amount)
	health.set_health(health_amount)
	SignalManager.health_depleted.connect(_on_health_depleted)


func _check_wall_rays() -> void:
	# Checks vertical
	if $WallRays/Up.is_colliding() and move_direction.y < 0:
		move_direction.y = abs(move_direction.y)
	elif $WallRays/Down.is_colliding() and move_direction.y > 0:
		move_direction.y = -abs(move_direction.y)
	# Checks horizontal
	if $WallRays/Right.is_colliding() and move_direction.x > 0:
		move_direction.x = -abs(move_direction.x)
	elif $WallRays/Left.is_colliding() and move_direction.x < 0:
		move_direction.x = abs(move_direction.x)


func _on_explosion_detector_area_entered(area: Area2D) -> void:
	if area.name == "ExplosionDetectionArea":
		modulate = explosion_detected_modulate


func _on_explosion_detector_area_exited(area: Area2D) -> void:
	if area.name == "ExplosionDetectionArea":
		modulate = base_modulate


func _on_health_changed(health_node: Health, _diff: int) -> void:
	if health_node == $Health:
		var health_ratio: float = float(health_node.health) / float(health_node.max_health)
		
		if health_ratio <= 0.5:
			shape_sprite.texture = preload("uid://cls1p7i0ixput")
			var modulate_change: float = 0.9
			explosion_detected_modulate *= modulate_change
			explosion_detected_modulate.a = 1.0
			base_modulate *= modulate_change
			base_modulate.a = 1.0


func _on_health_depleted(health_node: Health) -> void:
	if health_node in get_children():
		
		$ShapeBreakBehaviorNode.handle_break(type)
