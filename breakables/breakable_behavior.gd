# This files whole purpose is to separate the logic without having different compoenents
extends Node

func handle_break(_break_type: Enums.BreakableType) -> void:
	# To Do: Handle logic based on type
	SignalManager.breakable_broken.emit(get_parent())
	get_parent().queue_free()


func handle_normal() -> void:
	pass


func handle_explosive() -> void:
	pass


func handle_spawnder() -> void:
	pass
