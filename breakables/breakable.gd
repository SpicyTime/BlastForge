class_name Breakable
extends Node2D
@onready var breakable_sprite: Sprite2D = $BreakableSprite
@onready var hurtbox_collider: CollisionShape2D = $Hurtbox/HurtboxCollider
@onready var health: Health = $Health
var shape_component: ShapeComponent = null

func _ready() -> void:
	var collision_shape: Shape2D = shape_component.get_shape_collider()
	hurtbox_collider.shape = collision_shape
	breakable_sprite.texture = shape_component.get_shape_texture()
	var health_amount = shape_component.get_shape_health()
	health.set_health(health_amount)
	health.set_max_health(health_amount)
	SignalManager.health_depleted.connect(_on_health_depleted)


func _on_health_depleted(health_node: Health) -> void:
	print("Depleted")
	if health_node in get_children():
		queue_free()
