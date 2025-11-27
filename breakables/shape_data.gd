class_name ShapeData
extends Resource
@export var shape_texture: Texture2D = null
@export var shape_type: Enums.ShapeType = Enums.ShapeType.TRIANGLE
@export var shape_size: Enums.ShapeSize = Enums.ShapeSize.SMALL
@export var health_amount: int = 0
@export var base_point_value: int = 1
@export var shape_collider: Shape2D
func choose_random_size() -> Enums.ShapeSize:
	return randi_range(0, Enums.ShapeSize.size()) as Enums.ShapeSize
