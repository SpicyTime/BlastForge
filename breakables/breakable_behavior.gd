# This files whole purpose is to separate the logic without having different compoenents
extends Node
var breakable_spawn_number: int = 3
func handle_break(_break_type: Enums.BreakableType) -> void:
	# To Do: Handle logic based on type
	SignalManager.breakable_broken.emit(get_parent())
	get_parent().queue_free()
	var parent_breakable_type: Enums.BreakableType = get_parent().type
	if parent_breakable_type == Enums.BreakableType.NORMAL:
		pass
	elif parent_breakable_type == Enums.BreakableType.SPAWNER:
		handle_spawner()


func handle_normal() -> void:
	pass


func handle_explosive() -> void:
	pass


func handle_spawner() -> void:
	var spawn_positions: Array[Vector2] = [get_parent().to_global(Vector2(0, -8)), get_parent().to_global(Vector2(-5, 8)), get_parent().to_global(Vector2(5, 8))]
	var shape_types: Array[Enums.ShapeType] = []
	var breakable_types: Array[Enums.BreakableType] = []
	for i in range(breakable_spawn_number):
		shape_types.append(Enums.ShapeType.TRIANGLE)
		breakable_types.append(Enums.BreakableType.NORMAL)

	SignalManager.spawn_breakable_bunch_request.emit(breakable_spawn_number, spawn_positions, shape_types, breakable_types)
