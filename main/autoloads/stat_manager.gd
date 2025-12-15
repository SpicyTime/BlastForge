extends Node
# Explosives
var explosive_damage: int = 100
var explosive_explosion_radius: float = 48
var explosive_place_delay: float = 0.2
# Breakable Spawning
var breakable_spawn_limit: int = 20
var breakable_bunch_spawn_chance: float = 0.08
var breakable_spawn_time: float = 1.3
var despawn_time_multiplier: float = 2.1
var despawn_threshold: float = breakable_spawn_limit * 0.75
var breakable_type_weights: Dictionary[Enums.BreakableType, float] = {
	Enums.BreakableType.NORMAL : 1.0,
	Enums.BreakableType.EXPLOSIVE : 0.0,
	Enums.BreakableType.SPAWNER : 0.0
}

var shape_type_weights: Dictionary[Enums.ShapeType, float] = {
	Enums.ShapeType.TRIANGLE : 1.0,
	Enums.ShapeType.SQUARE : 0.0,
	Enums.ShapeType.PENTAGON : 0.0,
	Enums.ShapeType.HEXAGON : 0.0,
	Enums.ShapeType.CIRCLE : 0.0
}

var triangle_size_weights: Dictionary[Enums.ShapeSize, float] = {
	Enums.ShapeSize.SMALL : 1.0,
	Enums.ShapeSize.MEDIUM : 1.0,
	Enums.ShapeSize.LARGE : 1.0
}
var square_size_weights: Dictionary[Enums.ShapeSize, float] = {
	Enums.ShapeSize.SMALL : 1.0,
	Enums.ShapeSize.MEDIUM : 1.0,
	Enums.ShapeSize.LARGE : 1.0
}
var pentagon_size_weights: Dictionary[Enums.ShapeSize, float] = {
	Enums.ShapeSize.SMALL : 1.0,
	Enums.ShapeSize.MEDIUM : 1.0,
	Enums.ShapeSize.LARGE : 1.0
}
var hexagon_size_weights: Dictionary[Enums.ShapeSize, float] = {
	Enums.ShapeSize.SMALL : 1.0,
	Enums.ShapeSize.MEDIUM : 1.0,
	Enums.ShapeSize.LARGE : 1.0
}
var circle_size_weights: Dictionary[Enums.ShapeSize, float] = {
	Enums.ShapeSize.SMALL : 1.0,
	Enums.ShapeSize.MEDIUM : 1.0,
	Enums.ShapeSize.LARGE : 1.0
}

var type_size_weight_table_lookup: Dictionary[Enums.ShapeType, Dictionary] = {
	Enums.ShapeType.TRIANGLE : triangle_size_weights,
	Enums.ShapeType.SQUARE : square_size_weights,
	Enums.ShapeType.PENTAGON : pentagon_size_weights, 
	Enums.ShapeType.HEXAGON : hexagon_size_weights,
	Enums.ShapeType.CIRCLE : circle_size_weights
}

func get_explosive_damage() -> int:
	return explosive_damage


func get_explosion_radius() -> float:
	return explosive_explosion_radius 


func get_shader_radius() -> float:
	return get_explosion_radius() * 0.64


func get_place_delay() -> float:
	return explosive_place_delay


func get_breakable_spawn_limit() -> int:
	return breakable_spawn_limit


func get_breakable_bunch_spawn_chance() -> float:
	return breakable_bunch_spawn_chance


func get_shape_type_weights() -> Dictionary[Enums.ShapeType, float]:
	return shape_type_weights


func get_breakable_type_weights() -> Dictionary[Enums.BreakableType, float]:
	return breakable_type_weights


func get_breakable_spawn_time() -> float:
	return breakable_spawn_time


func get_breakable_despawn_time() -> float:
	return get_breakable_spawn_time() * despawn_time_multiplier


func get_despawn_threshold() -> float:
	return despawn_threshold


func get_shape_size_weights(shape_type: Enums.ShapeType) -> Dictionary[Enums.ShapeSize, float]:
	return type_size_weight_table_lookup[shape_type]
