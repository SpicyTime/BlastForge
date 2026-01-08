extends Node
const MYSTERY = preload("uid://cdbe4cwxplk83")
const SUSPENSE_PULSE = preload("uid://gwupsm1qifj7")
const SUSPENSE_PULSE_TENSE = preload("uid://csl7fpgep6fag")
const SUSPENSE_TENSION = preload("uid://bc8pxvib31qyn")

func _ready() -> void:
	UiManager.set_up_ui(get_child(1))
	UiManager.show_overlay("Hud")
	AudioManager.set_music_node($Music)
	AudioManager.set_audio_contianer($AudioHolder)
	#AudioManager.start_music(SUSPENSE_PULSE_TENSE)
	
	Console.pause_enabled = true
	Input.set_custom_mouse_cursor(Constants.OPEN_HAND_CURSOR_ICON, Input.CURSOR_ARROW, Constants.OPEN_HAND_CURSOR_ICON.get_size() / 2)
	Input.set_custom_mouse_cursor(Constants.POINTER_HAND_CURSOR_ICON, Input.CURSOR_POINTING_HAND)
	
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event: InputEvent) -> void:
	pass
	
