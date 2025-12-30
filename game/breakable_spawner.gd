extends Node2D
var spawn_time_passed: float = 0.0
var despawn_time_passed: float = 0.0

var break_behavior_type_lookup: Dictionary[Enums.BreakBehavior, String] = {
	Enums.BreakBehavior.NORMAL : "normal",
	Enums.BreakBehavior.EXPLOSIVE  : "explosive",
	Enums.BreakBehavior.SPAWNER  : "spawner"
}

var shape_type_lookup: Dictionary[Enums.ShapeType, String] = {
	Enums.ShapeType.TRIANGLE : "triangle",
	Enums.ShapeType.SQUARE : "square",
	Enums.ShapeType.PENTAGON : "pentagon",
	Enums.ShapeType.HEXAGON : "hexagon",
	Enums.ShapeType.CIRCLE : "circle",
}

const MAX_BREAKABLE_SPEED: int = 2400
const MIN_BREAKABLE_SPEED: int = 3000

func _ready() -> void:
	SignalManager.spawn_shape_request.connect(_on_spawn_shape_requested)
	SignalManager.spawn_shape_bunch_request.connect(_on_spawn_shape_bunch_requested)


func _process(delta: float) -> void:
	_handle_shape_auto_spawn(delta)
	#_handle_shape_auto_despawn(delta)


func spawn_shape(spawn_position: Vector2, shape_type: Enums.ShapeType, break_behavior_type: Enums.BreakBehavior = Enums.BreakBehavior.NORMAL) -> Shape:
	# Initializes the actual shape object
	var packed_shape_scene: PackedScene = load(Constants.SHAPE_SCENE_PATH)
	var shape_instance: Shape = packed_shape_scene.instantiate()
	shape_instance.position = spawn_position
	shape_instance.type = break_behavior_type
	# Initializes the data for the desired shape (based off of the name)
	var shape_data: ShapeData = load(Constants.SHAPE_RESOURCE_PATH_START + shape_type_lookup[shape_type] + Constants.SHAPE_RESOURCE_PATH_END).duplicate()
	
	# Sets the shape data variable
	shape_data.shape_type = shape_type
	shape_instance.shape_data = shape_data
	shape_instance.move_direction = _choose_random_direction()
	shape_instance.speed = _choose_random_speed()
	shape_instance.base_speed = shape_instance.speed
	shape_data.shape_size = _choose_random_shape_size(shape_type)
	
	add_child(shape_instance)
	return shape_instance


func spawn_shape_bunch(amount: int, spawn_positions: Array[Vector2], shape_types: Array[Enums.ShapeType], break_behavior_types: Array[Enums.BreakBehavior]) -> void:
	for i in range(amount):
		spawn_shape(spawn_positions[i], shape_types[i], break_behavior_types[i])


func _handle_shape_auto_spawn(delta: float) -> void:
	spawn_time_passed += delta
	var world_spawn_bounds: Array[int] = [-600, 600, -300, 300]
	if spawn_time_passed >= StatManager.get_shape_spawn_stat("spawn_time"): 
		
		spawn_time_passed = 0.0
		# If the max amount of shapes has not been reached, we spawn a new one.
		if get_child_count() < StatManager.get_shape_spawn_stat("spawn_limit"):
			
			var bunch_spawn_roll: float = randi_range(0, 100)
			if bunch_spawn_roll <= StatManager.get_shape_spawn_stat("bunch_spawn_chance"):
				
				var shape_position: Vector2 = _choose_random_pos(world_spawn_bounds)
				var shape_spawn_bunch_number: int = StatManager.get_shape_spawn_stat("bunch_spawn_number")
				var spawn_positions: Array[Vector2] = []
				var shape_types: Array[Enums.ShapeType] = []
				var break_behavior_types: Array[Enums.BreakBehavior] = []
				# Spawns x amount of shapes, setting all the datas for each
				for i in range(shape_spawn_bunch_number):
					var offset_bounds: Array[int] = [-40, 40, -40, 40]
					var shape_position_offset: Vector2 =_choose_random_pos(offset_bounds)
					var chosen_shape_type: Enums.ShapeType = _choose_random_shape_type()
					var chosen_break_behavior_type: Enums.BreakBehavior = _choose_random_break_behavior_type()
					shape_types.append(chosen_shape_type)
					break_behavior_types.append(chosen_break_behavior_type)
					spawn_positions.append(shape_position + shape_position_offset)
				spawn_shape_bunch(shape_spawn_bunch_number, spawn_positions, shape_types, break_behavior_types)
			else: 
				# Order: left, right, top, bottom
				var shape_position: Vector2 = _choose_random_pos(world_spawn_bounds)
				var chosen_shape_type: Enums.ShapeType = _choose_random_shape_type()
				var chosen_break_behavior_type: Enums.BreakBehavior = _choose_random_break_behavior_type()
				spawn_shape(shape_position, chosen_shape_type, chosen_break_behavior_type)


func _handle_shape_auto_despawn(delta) -> void:
	despawn_time_passed += delta
	var despawn_time: float = StatManager.get_despawn_time()
	if despawn_time_passed >= despawn_time and get_child_count() >= StatManager.get_despawn_threshold():
		despawn_time_passed = 0.0
		get_child(0).handle_despawn()

# Generic weighted table total function
func _calc_weighted_table_total(weighted_table: Dictionary) -> float:
	var total: float = 0.0
	for value in weighted_table:
		total += value
	return total


# Chooses a random shape type based off of a weighted table
func _choose_random_shape_type() -> Enums.ShapeType:
	var shape_type_weights: Dictionary[Enums.ShapeType, float] = StatManager.get_shape_type_weights()
	var weight_roll: float = randf() * _calc_weighted_table_total(shape_type_weights)
	# Goes through the weights to eventually choose the type
	for shape_type in shape_type_weights.keys():
		weight_roll -= shape_type_weights[shape_type]
		if weight_roll <= 0.0: return shape_type
	# Fall back
	return Enums.ShapeType.TRIANGLE

# Chooses a random shape type based off of a weighted table 
func _choose_random_break_behavior_type() -> Enums.BreakBehavior:
	var break_behavior_type_weights: Dictionary[Enums.BreakBehavior, float] = StatManager.get_break_behavior_type_weights()
	var weight_roll: float = randf() * _calc_weighted_table_total(break_behavior_type_weights)
	# Goes through the weights to eventually choose the type
	for break_behavior_type in break_behavior_type_weights.keys():
		weight_roll -= break_behavior_type_weights[break_behavior_type]
		if weight_roll <= 0.0: return break_behavior_type
	return Enums.BreakBehavior.NORMAL


func _choose_random_shape_size(shape_type: Enums.ShapeType) -> Enums.ShapeSize:
	var size_type_weights: Dictionary = StatManager.get_shape_size_weights(shape_type)
	var weight_roll: float = randf() * _calc_weighted_table_total(size_type_weights)
	for size_type in size_type_weights.keys():
		weight_roll -= size_type_weights[size_type]
		if weight_roll <= 0.0: return size_type
	return Enums.ShapeSize.SMALL 


func _choose_random_pos(spawn_position_bounds: Array[int]) -> Vector2:
	var left: int = spawn_position_bounds[0]
	var right: int = spawn_position_bounds[1]
	var top: int = spawn_position_bounds[2]
	var bottom: int = spawn_position_bounds[3]
	var viewport_size: Vector2 = get_viewport_rect().size
	# Makes sure that the bounds are not outside the viewport
	
	left   = clamp(left, -viewport_size.x / 2, 0)
	right  = clamp(right, 0, viewport_size.x / 2)
	top    = clamp(top, -viewport_size.y / 2, 0)
	bottom = clamp(bottom, 0, viewport_size.y / 2)
	
	var x: float = randf_range(left, right)
	var y: float = randf_range(bottom, top)
	# Snaps the position to a grid
	var rand_position: Vector2 = Vector2(x, y).snapped(Vector2(Constants.TILE_SIZE, Constants.TILE_SIZE))
	return rand_position 


func _choose_random_direction() -> Vector2:
	return Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()


func _choose_random_speed() -> int:
	return randi_range(MIN_BREAKABLE_SPEED, MAX_BREAKABLE_SPEED)


func _on_spawn_shape_requested(spawn_position: Vector2, shape_type: Enums.ShapeType, break_behavior_type: Enums.BreakBehavior) -> void:
	spawn_shape(spawn_position, shape_type, break_behavior_type)
 

func _on_spawn_shape_bunch_requested(amount: int, spawn_positions: Array[Vector2], shape_types: Array[Enums.ShapeType], break_behavior_types: Array[Enums.BreakBehavior]) -> void:
	spawn_shape_bunch(amount, spawn_positions, shape_types, break_behavior_types)
