class_name ShapeComponent
extends Node
var shape_data: ShapeData = null


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
	return shape_data.base_point_value
