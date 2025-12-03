class_name ShapeData
extends Resource
@export var shape_texture: Texture2D = null
@export var shape_type: Enums.ShapeType = Enums.ShapeType.TRIANGLE
@export var shape_size: Enums.ShapeSize = Enums.ShapeSize.SMALL
@export var health_amount: int = 0
@export var base_point_value: int = 1
@export var shape_collider: Shape2D
@export var size_type_weights: Dictionary[Enums.ShapeSize, float] = {
	Enums.ShapeSize.SMALL : 1.0,
	Enums.ShapeSize.MEDIUM : 1.0,
	Enums.ShapeSize.LARGE : 1.0
}

func calc_size_weight_total() -> float:
	var total_weight: float = 0.0
	for weight in size_type_weights:
		total_weight += weight
	return total_weight


func choose_random_size() -> Enums.ShapeSize:
	var weight_roll: float = randf() * calc_size_weight_total()
	# Goes through the weights to eventually choose the type
	for size_type in size_type_weights.keys():
		weight_roll -= size_type_weights[size_type]
		if weight_roll <= 0.0: return size_type
	return Enums.ShapeSize.SMALL
