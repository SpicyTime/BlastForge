class_name ShapeComponent
extends Node
var shape_data: ShapeData = null
var shape_value: int = 0
func _ready() -> void:
	shape_value = _calc_shape_value()


func set_data(data: ShapeData) -> void:
	shape_data = data


func get_shape_collider() -> Shape2D:
	return shape_data.shape_collider


func get_shape_type() -> Enums.ShapeType:
	return shape_data.shape_type


func get_shape_size() -> Enums.ShapeSize:
	return shape_data.shape_size


func get_shape_texture() -> Texture2D:
	return shape_data.shape_texture


func get_shape_health() -> int:
	return shape_data.health_amount


func get_shape_value() -> int:
	return shape_value

func _calc_shape_value() -> int:
	var size_multiplier_value: float = 0.0
	if get_shape_size() == Enums.ShapeSize.SMALL:
		size_multiplier_value = Constants.BASE_SMALL_MULTIPLIER
	elif get_shape_size() == Enums.ShapeSize.MEDIUM:
		size_multiplier_value = Constants.BASE_MEDIUM_MULTIPLIER
	else:
		size_multiplier_value = Constants.BASE_LARGE_MULTIPLIER
	return int(shape_data.base_point_value * size_multiplier_value)
