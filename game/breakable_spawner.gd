extends Node2D
var time_passed: float = 0.0
const MIN_SPAWN_VALUE: float = 0.0

func _process(delta: float) -> void:
	time_passed += delta
	if time_passed >= 0.9:
		time_passed = 0.0
		var breakable_position: Vector2 = choose_random_pos(-275, 275, -150, 150)
		spawn_breakable(breakable_position, "pentagon")
		spawn_breakable(choose_random_pos(-275, 275, -150, 150), "triangle")
		spawn_breakable(choose_random_pos(-275, 275, -150, 150), "square")
		spawn_breakable(choose_random_pos(-275, 275, -150, 150), "circle")
		spawn_breakable(choose_random_pos(-275, 275, -150, 150), "hexagon")


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
	
