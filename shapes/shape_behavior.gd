# This files whole purpose is to separate the logic without having different components
extends Node
var shape_spawn_number: int = 3
var shape: Shape = null

func _ready() -> void:
	shape = get_parent()


func handle_break(_break_type: Enums.BreakBehavior) -> void:
	# To Do: Handle logic based on type
	var parent_break_behavior_type: Enums.BreakBehavior = shape.type
	if parent_break_behavior_type == Enums.BreakBehavior.NORMAL:
		pass
	elif parent_break_behavior_type == Enums.BreakBehavior.SPAWNER:
		handle_spawner()
	else:
		handle_exploder()
	SignalManager.shape_broken.emit(shape)


func handle_normal() -> void:
	pass


func handle_exploder() -> void:
	# Other data might need to be sent, but this is it for now
	SignalManager.spawn_explosive.emit(shape.position)


func handle_spawner() -> void:
	var spawn_positions: Array[Vector2] = [shape.to_global(Vector2(0, -8)), shape.to_global(Vector2(-5, 8)), get_parent().to_global(Vector2(5, 8))]
	var shape_types: Array[Enums.ShapeType] = []
	var break_behavior_types: Array[Enums.BreakBehavior] = []
	for i in range(shape_spawn_number):
		shape_types.append(Enums.ShapeType.TRIANGLE)
		break_behavior_types.append(Enums.BreakBehavior.NORMAL)

	SignalManager.spawn_shape_bunch_request.emit(shape_spawn_number, spawn_positions, shape_types, break_behavior_types)
