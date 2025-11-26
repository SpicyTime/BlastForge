class_name Breakable
extends Node2D
@onready var breakable_sprite: Sprite2D = $BreakableSprite
@onready var hurtbox_collider: CollisionShape2D = $Hurtbox/HurtboxCollider
@onready var detector_collider: CollisionShape2D = $ExplosionDetector/DetectorCollider
@onready var health: Health = $Health
var shape_component: ShapeComponent = null
var base_modulate: Color = modulate
var explosion_detected_modulate: Color = Color(0.5, 0.5, 0.5)

func _ready() -> void:
	var collision_shape: Shape2D = shape_component.get_shape_collider()
	hurtbox_collider.shape = collision_shape
	detector_collider.shape = collision_shape
	breakable_sprite.texture = shape_component.get_shape_texture()
	var health_amount = shape_component.get_shape_health()
	health.set_health(health_amount)
	health.set_max_health(health_amount)
	SignalManager.health_depleted.connect(_on_health_depleted)


func _on_health_depleted(health_node: Health) -> void:
	if health_node in get_children():
		queue_free()


func _on_explosion_detector_area_entered(area: Area2D) -> void:
	if area.name == "ExplosionDetectionArea":
		modulate = explosion_detected_modulate


func _on_explosion_detector_area_exited(area: Area2D) -> void:
	if area.name == "ExplosionDetectionArea":
		modulate = base_modulate
