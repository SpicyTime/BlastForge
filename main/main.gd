extends Node

func _ready() -> void:
	UiManager.set_up_ui(get_child(1))
	UiManager.show_overlay("Hud")
	Console.pause_enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
