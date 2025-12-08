class_name World
extends Node2D
var held_explosive: Explosive = null
@onready var explosives_container: Node2D = $ExplosivesContainer

func _ready() -> void:
	SignalManager.breakable_broken.connect(_on_breakable_broken)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_position: Vector2 = get_global_mouse_position()
		# The explosive will be created when the explosive_action is pressed
		if Input.is_action_just_pressed("explosive_action") and not held_explosive:
			held_explosive = create_explosive(mouse_position)
		# The explosive will be placed when the explosive_action is released
		if Input.is_action_just_released("explosive_action") and held_explosive:
			call_deferred("place_explosive") 
	elif event is InputEventMouseMotion:
		if held_explosive:
			held_explosive.position = get_global_mouse_position()


# Initializes an explosive at a certain position (usually the mouse position)
func create_explosive(spawn_position: Vector2) -> Explosive:
	var packed_explosive_scene: PackedScene = load(Constants.EXPLOSIVE_SCENE_PATH)
	var explosive_instance: Explosive = packed_explosive_scene.instantiate()
	explosive_instance.position = spawn_position
	# I get a bunch of errors if it is not deferred
	explosives_container.call_deferred("add_child", explosive_instance)
	return explosive_instance

 
func place_explosive() -> void:
	if held_explosive:
		held_explosive.handle_placed()
		# This effectively "places" the bomb by not resetting its position to the mouse
		held_explosive = null 


func spawn_floating_text(text: String, text_position: Vector2, text_color: Color, visible_time: float):
	var floating_text: Marker2D = load(Constants.FLOATING_TEXT_PATH).instantiate()
	var text_label: Label = floating_text.get_child(0)
	floating_text.exist_time = visible_time
	text_label.text = text
	floating_text.position = text_position
	text_label.add_theme_color_override("font_color", text_color)
	add_child(floating_text)
	await get_tree().create_timer(visible_time).timeout
	floating_text.queue_free()


func _on_breakable_broken(breakable_instance: Breakable) -> void:
	var text = "+" + str(breakable_instance.shape_component.get_shape_value())
	
	spawn_floating_text(text ,breakable_instance.position + Vector2(0, -10.0), Color.GREEN, 1.15)


func spawn_explosive(explosive_position: Vector2):
	var explosive_instance: Explosive = create_explosive(explosive_position)
	# Matches the defer in the creation
	explosive_instance.call_deferred("handle_placed")
