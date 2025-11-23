class_name Breakable
extends Node2D
@onready var breakable_sprite: Sprite2D = $BreakableSprite
@onready var hurtbox_collider: CollisionShape2D = $Hurtbox/HurtboxCollider
@onready var shape_component: ShapeComponent = $ShapeComponent


func _ready() -> void:
	var collision_shape: Shape2D = shape_component.get_shape_collider()
	hurtbox_collider.shape = collision_shape
	breakable_sprite.texture = shape_component.get_shape_texture()
