class_name Breakable
extends Node2D
@onready var breakable_sprite: Sprite2D = $BreakableSprite
@onready var hurtbox_collider: CollisionShape2D = $Hurtbox/HurtboxCollider
@onready var detector_collider: CollisionShape2D = $ExplosionDetector/DetectorCollider
@onready var health: Health = $Health

var shape_component: ShapeComponent = null
var base_modulate: Color = modulate
var explosion_detected_modulate: Color = Color(0.5, 0.5, 0.5)
var type: Enums.BreakableType = Enums.BreakableType.NORMAL
var is_scaled: bool = false
var size_scales: Dictionary[Enums.ShapeSize, float] = {
	Enums.ShapeSize.SMALL : 1.0,
	Enums.ShapeSize.MEDIUM : 1.15,
	Enums.ShapeSize.LARGE :  1.35
}


func _ready() -> void:
	_set_up_colliders()
	_set_up_health()
	breakable_sprite.texture = shape_component.get_shape_texture()
	breakable_sprite.scale = Vector2.ZERO
	var final_scale: Vector2 = Vector2(size_scales[shape_component.get_shape_size()], size_scales[shape_component.get_shape_size()])
	var scale_up_tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	var scale_up_time: float = 0.2
	scale_up_tween.tween_property(breakable_sprite, "scale", final_scale, scale_up_time)
	# This will make it feel a little nicer
	await get_tree().create_timer(scale_up_time / 2).timeout
	hurtbox_collider.disabled = false


func handle_despawn() -> void:
	var scale_down_tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	var scale_down_time: float = 0.3
	scale_down_tween.tween_property(breakable_sprite, "scale", Vector2.ZERO, scale_down_time)
	# Allows it to still be blown up for a bit
	await get_tree().create_timer(scale_down_time * 0.75).timeout
	if is_instance_valid(self): # Checks if the breakable has been destroyed
		hurtbox_collider.disabled = true
		await scale_down_tween.finished # Checks if the breakable has been destroyed
		queue_free()


func _set_up_colliders() -> void:
	# Sets Colliders
	var collision_shape: Shape2D = shape_component.get_shape_collider()
	hurtbox_collider.set_deferred("shape", collision_shape)
	detector_collider.set_deferred("shape", collision_shape)


func _set_up_health() -> void:
	var health_amount = shape_component.get_shape_health()
	health.set_health(health_amount)
	health.set_max_health(health_amount)
	SignalManager.health_depleted.connect(_on_health_depleted)
	


func _on_health_depleted(health_node: Health) -> void:
	if health_node in get_children():
		$BreakableBehavior.handle_break(type)


func _on_explosion_detector_area_entered(area: Area2D) -> void:
	if area.name == "ExplosionDetectionArea":
		modulate = explosion_detected_modulate


func _on_explosion_detector_area_exited(area: Area2D) -> void:
	if area.name == "ExplosionDetectionArea":
		modulate = base_modulate
