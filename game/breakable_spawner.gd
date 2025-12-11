extends Node2D
const MIN_SPAWN_VALUE: float = 0.0
var spawn_time_passed: float = 0.0
var despawn_time_passed: float = 0.0
var spawn_limit: int = 20
var spawn_time_limit: float = 1.3
var despawn_time_limit: float = spawn_time_limit * 2.1
var despawn_threshold: int = int(spawn_limit / 1.5)
var bunch_spawn_chance: float = 0.08
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

var breakable_type_lookup: Dictionary[Enums.BreakableType, String] = {
	Enums.BreakableType.NORMAL : "normal",
	Enums.BreakableType.EXPLOSIVE  : "explosive",
	Enums.BreakableType.SPAWNER  : "spawner"
}

var shape_type_lookup: Dictionary[Enums.ShapeType, String] = {
	Enums.ShapeType.TRIANGLE : "triangle",
	Enums.ShapeType.SQUARE : "square",
	Enums.ShapeType.PENTAGON : "pentagon",
	Enums.ShapeType.HEXAGON : "hexagon",
	Enums.ShapeType.CIRCLE : "circle",
}

const MAX_BREAKABLE_SPEED: int = 645
const MIN_BREAKABLE_SPEED: int = 730

func _ready() -> void:
	SignalManager.spawn_breakable_request.connect(_on_spawn_breakable_requested)
	SignalManager.spawn_breakable_bunch_request.connect(_on_spawn_breakable_bunch_requested)


func _process(delta: float) -> void:
	_handle_breakable_auto_spawn(delta)
	_handle_breakable_auto_despawn(delta)


func spawn_breakable(spawn_position: Vector2, shape_type: Enums.ShapeType, breakable_type: Enums.BreakableType = Enums.BreakableType.NORMAL) -> Breakable:
	# Initializes the actual breakable object
	var packed_breakable_scene: PackedScene = load(Constants.BREAKABLE_SCENE_PATH)
	var breakable_instance: Breakable = packed_breakable_scene.instantiate()
	breakable_instance.position = spawn_position
	breakable_instance.type = breakable_type
	# Initializes the data for the desired shape (based off of the name)
	var shape_data: ShapeData = load(Constants.SHAPE_RESOURCE_PATH_START + shape_type_lookup[shape_type] + Constants.SHAPE_RESOURCE_PATH_END).duplicate()
	shape_data.shape_type = shape_type
	shape_data.shape_size = shape_data.choose_random_size()
	# Initializes the shape component
	var packed_shape_component: PackedScene = load(Constants.SHAPE_COMPONENT_PATH)
	var shape_component_instance: ShapeComponent = packed_shape_component.instantiate()
	shape_component_instance.set_data(shape_data)
	
	# Adds the component to the breakable object
	breakable_instance.shape_component = shape_component_instance
	breakable_instance.move_direction = _choose_random_direction()
	breakable_instance.speed = _choose_random_speed()
	breakable_instance.base_speed = breakable_instance.speed
	breakable_instance.add_child(shape_component_instance)
	
	add_child(breakable_instance)
	return breakable_instance


func spawn_breakable_bunch(amount: int, spawn_positions: Array[Vector2], shape_types: Array[Enums.ShapeType], breakable_types: Array[Enums.BreakableType]) -> void:
	for i in range(amount):
		spawn_breakable(spawn_positions[i], shape_types[i], breakable_types[i])


func _handle_breakable_auto_spawn(delta: float) -> void:
	spawn_time_passed += delta
	var world_spawn_bounds: Array[int] = [-275, 275, -150, 150]
	if spawn_time_passed >= spawn_time_limit: 
		
		spawn_time_passed = 0.0
		if get_child_count() < spawn_limit:
			
			var bunch_spawn_roll: float = randf()
			if bunch_spawn_roll <= bunch_spawn_chance:
				
				var breakable_position: Vector2 = _choose_random_pos(world_spawn_bounds)
				var breakable_bunch_spawn_number: int = 2
				var spawn_positions: Array[Vector2] = []
				var shape_types: Array[Enums.ShapeType] = []
				var breakable_types: Array[Enums.BreakableType] = []
				
				for i in range(breakable_bunch_spawn_number):
					var offset_bounds: Array[int] = [-40, 40, -40, 40]
					var breakable_position_offset: Vector2 =_choose_random_pos(offset_bounds)
					var chosen_shape_type: Enums.ShapeType = _choose_random_shape_type()
					var chosen_breakable_type: Enums.BreakableType = _choose_random_breakable_type()
					shape_types.append(chosen_shape_type)
					breakable_types.append(chosen_breakable_type)
					spawn_positions.append(breakable_position + breakable_position_offset)
				spawn_breakable_bunch(breakable_bunch_spawn_number, spawn_positions, shape_types, breakable_types)
			else: 
				# Order: left, right, top, bottom
				var breakable_position: Vector2 = _choose_random_pos(world_spawn_bounds)
				var chosen_shape_type: Enums.ShapeType = _choose_random_shape_type()
				var chosen_breakable_type: Enums.BreakableType = _choose_random_breakable_type()
				spawn_breakable(breakable_position, chosen_shape_type, chosen_breakable_type)


func _handle_breakable_auto_despawn(delta) -> void:
	despawn_time_passed += delta
	if despawn_time_passed >= despawn_time_limit and get_child_count() >= despawn_threshold:
		despawn_time_passed = 0.0
		get_child(0).handle_despawn()

# Adds all the weights in the shape type weight table
func _calc_shape_weight_total() -> float:
	var total: float = 0.0
	for value in shape_type_weights.values():
		total += value
	return total

# Adds all the weights in the breakable type weight table
func _calc_breakable_weight_total() -> float:
	var total: float = 0.0
	for value in breakable_type_weights.values():
		total += value
	return total

# Chooses a random shape type based off of a weighted table
func _choose_random_shape_type() -> Enums.ShapeType:
	var weight_roll: float = randf() * _calc_shape_weight_total()
	# Goes through the weights to eventually choose the type
	for shape_type in shape_type_weights.keys():
		weight_roll -= shape_type_weights[shape_type]
		if weight_roll <= 0.0: return shape_type
	# Fall back
	return Enums.ShapeType.TRIANGLE

# Chooses a random breakable type based off of a weighted table 
func _choose_random_breakable_type() -> Enums.BreakableType:
	var weight_roll: float = randf() * _calc_breakable_weight_total()
	# Goes through the weights to eventually choose the type
	for breakable_type in breakable_type_weights.keys():
		weight_roll -= breakable_type_weights[breakable_type]
		if weight_roll <= 0.0: return breakable_type
	return Enums.BreakableType.NORMAL


func _choose_random_pos(spawn_position_bounds: Array[int]) -> Vector2:
	var left: int = spawn_position_bounds[0]
	var right: int = spawn_position_bounds[1]
	var top: int = spawn_position_bounds[2]
	var bottom: int = spawn_position_bounds[3]
	var viewport_size: Vector2 = get_viewport_rect().size
	# Makes sure that the bounds are not outside the viewport
	clamp(left, -viewport_size.x / 2,  MIN_SPAWN_VALUE)
	clamp(bottom, viewport_size.y / 2, MIN_SPAWN_VALUE)
	clamp(right, viewport_size.x / 2, MIN_SPAWN_VALUE)
	clamp(top, -viewport_size.y / 2, MIN_SPAWN_VALUE)
	
	var x: float = randf_range(left, right)
	var y: float = randf_range(bottom, top)
	# Snaps the position to a grid
	var rand_position: Vector2 = Vector2(x, y).snapped(Vector2(Constants.TILE_SIZE, Constants.TILE_SIZE))
	return rand_position 


func _choose_random_direction() -> Vector2:
	return Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()


func _choose_random_speed() -> int:
	return randi_range(MIN_BREAKABLE_SPEED, MAX_BREAKABLE_SPEED)


func _on_spawn_breakable_requested(spawn_position: Vector2, shape_type: Enums.ShapeType, breakable_type: Enums.BreakableType) -> void:
	spawn_breakable(spawn_position, shape_type, breakable_type)
 

func _on_spawn_breakable_bunch_requested(amount: int, spawn_positions: Array[Vector2], shape_types: Array[Enums.ShapeType], breakable_types: Array[Enums.BreakableType]) -> void:
	spawn_breakable_bunch(amount, spawn_positions, shape_types, breakable_types)
