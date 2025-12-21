extends Node

func _ready() -> void:
	UiManager.set_up_ui(get_child(1))
	UiManager.show_overlay("Hud")

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("toggle_console"):
		UiManager.show_overlay("DeveloperConsole")
