extends Node2D
const MIN_SPAWN_VALUE: float = 0.0
var spawn_time_passed: float = 0.0
var despawn_time_passed: float = 0.0
var spawn_limit: int = 20
var spawn_time_limit: float = 1.3
var despawn_time_limit: float = spawn_time_limit * 2.1
var despawn_threshold: int = int(spawn_limit / 1.5)
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
func _ready() -> void:
	SignalManager.spawn_breakable_request.connect(_on_spawn_breakable_requested)
	SignalManager.spawn_breakable_bunch_request.connect(_on_spawn_breakable_bunch_requested)


func _process(delta: float) -> void:
	spawn_time_passed += delta
	despawn_time_passed += delta
	if spawn_time_passed >= spawn_time_limit: 
		spawn_time_passed = 0.0
		if get_child_count() < spawn_limit:
			var breakable_position: Vector2 = choose_random_pos(-275, 275, -150, 150)
			spawn_breakable(breakable_position, Enums.ShapeType.TRIANGLE, Enums.BreakableType.SPAWNER)
	if despawn_time_passed >= despawn_time_limit and get_child_count() >= despawn_threshold:
		despawn_time_passed = 0.0
		get_child(0).queue_free()


func choose_random_pos(left: int, right: int, top: int, bottom: int ) -> Vector2:
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


func spawn_breakable(spawn_position: Vector2, shape_type: Enums.ShapeType, breakable_type: Enums.BreakableType = Enums.BreakableType.NORMAL) -> Breakable:
	# Initializes the actual breakable object
	var packed_breakable_scene: PackedScene = load(Constants.BREAKABLE_SCENE_PATH)
	var breakable_instance: Breakable = packed_breakable_scene.instantiate()
	breakable_instance.position = spawn_position
	breakable_instance.type = breakable_type
	# Initializes the data for the desired shape (based off of the name)
	var shape_data: ShapeData = load(Constants.SHAPE_RESOURCE_PATH_START + shape_type_lookup[shape_type] + Constants.SHAPE_RESOURCE_PATH_END)
	shape_data.shape_type = shape_type
	# Initializes the shape component
	var packed_shape_component: PackedScene = load(Constants.SHAPE_COMPONENT_PATH)
	var shape_component_instance: ShapeComponent = packed_shape_component.instantiate()
	shape_component_instance.set_data(shape_data)
	
	# Adds the component to the breakable object
	breakable_instance.shape_component = shape_component_instance
	breakable_instance.add_child(shape_component_instance)
	
	
	add_child(breakable_instance)
	return breakable_instance


func spawn_breakable_bunch(amount: int, spawn_positions: Array[Vector2], shape_types: Array[Enums.ShapeType], breakable_types: Array[Enums.BreakableType]) -> void:
	for i in range(amount):
		spawn_breakable(spawn_positions[i], shape_types[i], breakable_types[i])


func _on_spawn_breakable_requested(spawn_position: Vector2, shape_type: Enums.ShapeType, breakable_type: Enums.BreakableType) -> void:
	spawn_breakable(spawn_position, shape_type, breakable_type)

	# Another delay to wait out the bomb

func _on_spawn_breakable_bunch_requested(amount: int, spawn_positions: Array[Vector2], shape_types: Array[Enums.ShapeType], breakable_types: Array[Enums.BreakableType]) -> void:
	spawn_breakable_bunch(amount, spawn_positions, shape_types, breakable_types)
