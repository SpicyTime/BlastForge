extends Node
var total_points: int = 0

func _ready() -> void:
	SignalManager.breakable_broken.connect(_on_breakable_broken)
	UiManager.set_up_ui(get_child(1))
	UiManager.show_overlay("Hud")


func _on_breakable_broken(_breakable_position: Vector2, breakable_worth: int) -> void:
	total_points += breakable_worth
	SignalManager.points_changed.emit(total_points)
	
	
