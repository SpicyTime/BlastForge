extends Node

func _ready() -> void:
	UiManager.set_up_ui(get_child(1))
	UiManager.show_overlay("Hud")
	Console.pause_enabled = true
	Input.set_custom_mouse_cursor(Constants.OPEN_HAND_CURSOR_ICON, Input.CURSOR_ARROW, Constants.OPEN_HAND_CURSOR_ICON.get_size() / 2)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
