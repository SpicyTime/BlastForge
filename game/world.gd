class_name World
extends Node2D
var held_explosive: Explosive = null
var total_points: int = 0
var can_create_explosive: bool = true
@onready var explosives_container: Node2D = $ExplosivesContainer

func _ready() -> void:
	Console.add_command("set_points", _command_set_points, ["amount"], 1)
	SignalManager.explosive_detonated.connect(_on_explosive_detonated)
	SignalManager.upgrade_purchased.connect(_on_upgrade_purchased)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_position: Vector2 = get_global_mouse_position()
		# The explosive will be created when the explosive_action is pressed
		if Input.is_action_just_pressed("explosive_action") and not held_explosive and can_create_explosive:
			held_explosive = create_explosive(mouse_position)
			can_create_explosive = false
		# The explosive will be placed when the explosive_action is released
		if Input.is_action_just_released("explosive_action") and held_explosive:
			call_deferred("place_explosive") 
			get_tree().create_timer(StatManager.get_explosive_stat("place_delay")).connect("timeout", func(): can_create_explosive = true)
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


func spawn_explosive(explosive_position: Vector2):
	var explosive_instance: Explosive = create_explosive(explosive_position)
	# Matches the defer in the creation
	explosive_instance.call_deferred("handle_placed")


func _command_set_points(amount: String) -> void:
	_set_points(amount.to_int())


func _set_points(amount: int) -> void:
	total_points = amount
	SignalManager.points_changed.emit(total_points)


func _handle_shape_broken(shape_instance: Shape, bonus_multiplier: float = 1.0) -> void:
	var shape_type: Enums.ShapeType = shape_instance.shape_data.shape_type
	var size_type: Enums.ShapeSize = shape_instance.shape_data.shape_size
	var shape_value: int = ceil(StatManager.get_shape_value(shape_type, size_type) * bonus_multiplier)
	_set_points(total_points + shape_value)
	var text = "+" + str(shape_value)
	spawn_floating_text(text ,shape_instance.position + Vector2(0, -10.0), Color.GREEN, 1.15)
	shape_instance.queue_free()


func _on_explosive_detonated(shapes_broken: Array[Node2D]) -> void:
	var bonus_multiplier: float = 1.0
	var bonus_shape_threshold: int = 3
	if shapes_broken.size() >= bonus_shape_threshold:
		var exponent: float = 1.25
		bonus_multiplier = (StatManager.get_bunch_multiplier() + pow(shapes_broken.size() - bonus_shape_threshold, exponent))
		 
	for shape in shapes_broken:
		if is_instance_valid(shape) and shape is Shape:
			_handle_shape_broken(shape, bonus_multiplier) 
		else:
			print("Not Valid")


func _on_upgrade_purchased(upgrade: Upgrade) -> void:
	_set_points(total_points - upgrade.get_previous_price())
