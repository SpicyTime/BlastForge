# This files whole purpose is to separate the logic without having different compoenents
extends Node
var breakable_spawn_number: int = 3
var breakable: Breakable = null

func _ready() -> void:
	breakable = get_parent()


func handle_break(_break_type: Enums.BreakableType) -> void:
	# To Do: Handle logic based on type
	var parent_breakable_type: Enums.BreakableType = breakable.type
	if parent_breakable_type == Enums.BreakableType.NORMAL:
		pass
	elif parent_breakable_type == Enums.BreakableType.SPAWNER:
		handle_spawner()
	else:
		handle_exploder()
	SignalManager.breakable_broken.emit(breakable)
	breakable.queue_free()


func handle_normal() -> void:
	pass


func handle_exploder() -> void:
	# Other data might need to be sent, but this is it for now
	SignalManager.spawn_explosive.emit(breakable.position)


func handle_spawner() -> void:
	var spawn_positions: Array[Vector2] = [breakable.to_global(Vector2(0, -8)), breakable.to_global(Vector2(-5, 8)), get_parent().to_global(Vector2(5, 8))]
	var shape_types: Array[Enums.ShapeType] = []
	var breakable_types: Array[Enums.BreakableType] = []
	for i in range(breakable_spawn_number):
		shape_types.append(Enums.ShapeType.TRIANGLE)
		breakable_types.append(Enums.BreakableType.NORMAL)

	SignalManager.spawn_breakable_bunch_request.emit(breakable_spawn_number, spawn_positions, shape_types, breakable_types)
