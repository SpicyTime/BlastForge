extends Node
var total_points: int = 0

func _ready() -> void:
	SignalManager.breakable_broken.connect(_on_breakable_broken)
	UiManager.set_up_ui(get_child(1))
	UiManager.show_overlay("Hud")


func _on_breakable_broken(breakable_instance: Breakable) -> void:
	total_points += breakable_instance.shape_component.get_shape_value()
	SignalManager.points_changed.emit(total_points)
	
	
