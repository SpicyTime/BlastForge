extends Control


func _on_back_to_game_button_pressed() -> void:
	UiManager.swap_menu("None")
	UiManager.show_overlay("Hud")
