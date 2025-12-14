extends Node
var explosive_damage: int = 100
var explosive_explosion_radius: float = 100
var explosive_place_delay: float = 0.2
const COLLIDER_TO_SHADER_RATIO: float = 0.0155
func get_explosive_damage() -> int:
	return explosive_damage


func get_explosion_radius() -> float:
	return explosive_explosion_radius 


func get_shader_radius() -> float:
	return get_explosion_radius() * 0.64


func get_place_delay() -> float:
	return explosive_place_delay
