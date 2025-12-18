extends Node
# Explosives
var explosive_stats: Dictionary[String, float] = {
	"damage" : 100.0,
	"explosion_radius": 24.0,
	"place_delay": 0.2,
}

# Breakable Spawning
var breakable_spawn_stats: Dictionary[String, float] = {
	"spawn_limit": 20,
	"bunch_spawn_chance": 0.08,
	"spawn_time": 1.3,
}
var despawn_time_multiplier: float = 2.1
var despawn_threshold_ratio: float = 0.75

var size_multiplier_stats: Dictionary[String, int] = {
	"small": 1,
	"medium": 3,
	"large": 6
}
var bunch_multiplier: float = 1.5


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

var shape_size_weights: Dictionary[Enums.ShapeType, Dictionary] = {
	Enums.ShapeType.TRIANGLE: {
		Enums.ShapeSize.SMALL: 1.0,
		Enums.ShapeSize.MEDIUM: 1.0,
		Enums.ShapeSize.LARGE: 1.0
	},
	Enums.ShapeType.SQUARE: {
		Enums.ShapeSize.SMALL: 1.0,
		Enums.ShapeSize.MEDIUM: 1.0,
		Enums.ShapeSize.LARGE: 1.0
	},
	Enums.ShapeType.PENTAGON: {
		Enums.ShapeSize.SMALL: 1.0,
		Enums.ShapeSize.MEDIUM: 1.0,
		Enums.ShapeSize.LARGE: 1.0
	},
	Enums.ShapeType.HEXAGON: {
		Enums.ShapeSize.SMALL: 1.0,
		Enums.ShapeSize.MEDIUM: 1.0,
		Enums.ShapeSize.LARGE: 1.0
	},
	Enums.ShapeType.CIRCLE: {
		Enums.ShapeSize.SMALL: 1.0,
		Enums.ShapeSize.MEDIUM: 1.0,
		Enums.ShapeSize.LARGE: 1.0
	}
}

var shape_stats: Dictionary[Enums.ShapeType, Dictionary] = {
	Enums.ShapeType.TRIANGLE : {"points" : 1, "health" : 1},
	Enums.ShapeType.SQUARE : {"points" : 1, "health" : 1},
	Enums.ShapeType.PENTAGON : {"points" : 1, "health" : 1},
	Enums.ShapeType.HEXAGON : {"points" : 1, "health" : 1},
	Enums.ShapeType.CIRCLE : {"points" : 1, "health" : 1},
}

var unlocked_upgrades: Dictionary[String, Upgrade] = {}


func get_explosive_stats() -> Dictionary[String, float]:
	return explosive_stats


func get_explosive_stat(key: String) -> float:
	return explosive_stats[key]


func get_breakable_spawn_stats() -> Dictionary[String, float]:
	return breakable_spawn_stats


func get_breakable_spawn_stat(key: String) -> float:
	return breakable_spawn_stats[key]


func get_shape_size_weights(shape_type: Enums.ShapeType) -> Dictionary:
	return shape_size_weights[shape_type]


func get_shape_type_weights() -> Dictionary[Enums.ShapeType, float]:
	return shape_type_weights


func get_breakable_type_weights() -> Dictionary[Enums.BreakableType, float]:
	return breakable_type_weights


func get_shape_size_multiplier(shape_size: Enums.ShapeSize) -> int:
	if shape_size == Enums.ShapeSize.SMALL:
		return size_multiplier_stats["small"]
	elif shape_size == Enums.ShapeSize.MEDIUM:
		return size_multiplier_stats["medium"]
	return size_multiplier_stats["large"]


func get_despawn_threshold() -> float:
	return breakable_spawn_stats["spawn_limit"] * despawn_threshold_ratio


func get_bunch_multiplier() -> float:
	return bunch_multiplier 


func get_despawn_time() -> float:
	return breakable_spawn_stats["spawn_time"] * despawn_time_multiplier


func get_shape_value(shape_type: Enums.ShapeType, shape_size: Enums.ShapeSize) -> int:
	return shape_stats[shape_type]["points"] * get_shape_size_multiplier(shape_size)


func get_shape_health(shape_type: Enums.ShapeType) -> int:
	return shape_stats[shape_type]["health"]
