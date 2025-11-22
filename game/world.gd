extends Node2D
var held_explosive: Explosive = null
@onready var explosives_container: Node2D = $ExplosivesContainer

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_position: Vector2 = get_global_mouse_position()
		# The explosive will be created when the explosive_action is pressed
		if Input.is_action_just_pressed("explosive_action"):
			create_explosive(mouse_position)
		# The explosive will be placed when the explosive_action is released
		if Input.is_action_just_released("explosive_action"):
			place_explosive()
	elif event is InputEventMouseMotion:
		if held_explosive:
			held_explosive.position = get_global_mouse_position()


# Initializes an explosive at a certain position (usually the mouse position)
func create_explosive(spawn_position: Vector2) -> void:
	var packed_explosive_scene: PackedScene = load(Constants.EXPLOSIVE_SCENE_PATH)
	var explosive_instance: Explosive = packed_explosive_scene.instantiate()
	explosive_instance.position = spawn_position
	explosives_container.add_child(explosive_instance)
	held_explosive = explosive_instance

 
func place_explosive() -> void:
	# This effectively "places" the bomb by not resetting its position to the mouse
	held_explosive = null 
