extends Node2D
const MIN_SPAWN_VALUE: float = 0.0
var spawn_time_passed: float = 0.0
var despawn_time_passed: float = 0.0
var spawn_limit: int = 20
var spawn_time_limit: float = 1.3
var despawn_time_limit: float = spawn_time_limit * 2.1
var despawn_threshold: int = int(spawn_limit / 1.5)


func _process(delta: float) -> void:
	spawn_time_passed += delta
	despawn_time_passed += delta
	if spawn_time_passed >= spawn_time_limit: 
		spawn_time_passed = 0.0
		if get_child_count() < spawn_limit:
			var breakable_position: Vector2 = choose_random_pos(-275, 275, -150, 150)
			spawn_breakable(breakable_position, "triangle")
	if despawn_time_passed >= despawn_time_limit and get_child_count() >= despawn_threshold:
		despawn_time_passed = 0.0
		get_child(0).queue_free()


func spawn_breakable(spawn_position: Vector2, shape_name: String) -> Breakable:
	# Initializes the actual breakable object
	var packed_breakable_scene: PackedScene = load(Constants.BREAKABLE_SCENE_PATH)
	var breakabable_instance: Breakable = packed_breakable_scene.instantiate()
	breakabable_instance.position = spawn_position
	# Initializes the data for the desired shape (based off of the name)
	var shape_data: ShapeData = load(Constants.SHAPE_RESOURCE_PATH_START + shape_name + Constants.SHAPE_RESOURCE_PATH_END)
	# Initializes the shape component
	var packed_shape_component: PackedScene = load(Constants.SHAPE_COMPONENT_PATH)
	var shape_component_instance: ShapeComponent = packed_shape_component.instantiate()
	shape_component_instance.set_data(shape_data)
	
	# Adds the component to the breakable object
	breakabable_instance.shape_component = shape_component_instance
	breakabable_instance.add_child(shape_component_instance)
	
	add_child(breakabable_instance)
	return breakabable_instance


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
