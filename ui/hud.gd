extends Control
@export var base_shake_intensity: float = 2.0
@onready var points_label: Label = $InfoBox/PointsLabel
@onready var place_delay_progress_bar: TextureProgressBar = $MouseFollowerWrapper/PlaceDelayProgressBar
const RING_FILL_RED: Texture2D = preload("res://ui/assets/radial_progress_bar_textures/ring_fill_red.svg")
const RING_FILL_WHITE: Texture2D = preload("res://ui/assets/radial_progress_bar_textures/ring_fill_white.svg")
const RING_FILL_YELLOW: Texture2D = preload("res://ui/assets/radial_progress_bar_textures/ring_fill_yellow.svg")

var is_handling_unsuccessful_place: bool = false
var mouse_was_hidden = false
var progress_bar_cancel: bool = false
var dragging_bomb: bool = false
var mouse_inside_button: bool = false
func _ready() -> void:
	SignalManager.points_changed.connect(func(new_value: int) -> void: 
		points_label.text = "$" + str(new_value))
	SignalManager.bomb_detonated.connect(_on_bomb_detonated)
	SignalManager.bomb_placed.connect(func() -> void:
		dragging_bomb = false
		if mouse_inside_button:
			Input.set_custom_mouse_cursor(Constants.POINTER_HAND_CURSOR_ICON, Input.CURSOR_ARROW, Constants.POINTER_HAND_CURSOR_ICON.get_size() / 2)
		)
	SignalManager.purchase_amount_changed.connect(func(amount: int) -> void:
		if amount > 0:
			$Button/PlusSignRect.visible = true
		else:
			$Button/PlusSignRect.visible = false
		)
	SignalManager.place_delay_timer_changed.connect(_on_place_delay_timer_changed)
		
	SignalManager.unsuccessful_bomb_place.connect(_on_unsuccessful_bomb_place)
	SignalManager.bomb_created.connect(func() -> void:
		place_delay_progress_bar.visible = false
		dragging_bomb = true
		Input.set_custom_mouse_cursor(Constants.DRAG_HAND_CURSOR_ICON, Input.CURSOR_ARROW, Constants.DRAG_HAND_CURSOR_ICON.get_size() / 2)
		)
	place_delay_progress_bar.pivot_offset = place_delay_progress_bar.size * 0.5


func _process(_delta: float) -> void:
	$MouseFollowerWrapper.position = get_global_mouse_position() 


func _on_button_pressed() -> void:
	UiManager.swap_menu("UpgradeHub")
	UiManager.hide_overlay("Hud")


func _on_bomb_detonated(_shapes_broken: Array[Node2D]) -> void:
	var shake_intensity: float = base_shake_intensity + StatManager.get_bomb_stat("damage") * Constants.SCALE_RATIO
	shake_intensity = min(shake_intensity, Constants.UI_SHAKE_INTENSITY_CAP)
	$ShakeComponent.shake(shake_intensity, 0.8)


func _on_unsuccessful_bomb_place() -> void:
	if is_handling_unsuccessful_place:
		return
	is_handling_unsuccessful_place = true
	var base_size: Vector2 = Vector2(0.818, 0.818)
	
	var final_size:Vector2 = Vector2(1.0, 1.0)
	
	var tween_time: float = 0.06
	var hold_time: float = 0.22
	
	var ring_scale_up_tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	
	ring_scale_up_tween.tween_property(place_delay_progress_bar, "scale", final_size, tween_time)
	
	place_delay_progress_bar.texture_progress = RING_FILL_RED
	await ring_scale_up_tween.finished
	await get_tree().create_timer(hold_time).timeout
	place_delay_progress_bar.texture_progress = RING_FILL_YELLOW
	var ring_scale_down_tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	ring_scale_down_tween.tween_property(place_delay_progress_bar, "scale", base_size, tween_time)
	await ring_scale_down_tween.finished
	is_handling_unsuccessful_place = false


func _on_place_delay_timer_changed(value: float) -> void:
	if mouse_inside_button or not visible:
		return
	if value > 0.0:
		if not place_delay_progress_bar.visible and not progress_bar_cancel:
			place_delay_progress_bar.visible = true
			print("Hiding")
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		if not place_delay_progress_bar.texture_progress == RING_FILL_YELLOW and not is_handling_unsuccessful_place and not progress_bar_cancel:
			place_delay_progress_bar.texture_progress = RING_FILL_YELLOW
			print("Hiding")
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		place_delay_progress_bar.value = place_delay_progress_bar.max_value * (1 - value / StatManager.get_bomb_stat("place_delay"))
	else:
		place_delay_progress_bar.value = 100
		place_delay_progress_bar.visible = false
		if not Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.set_custom_mouse_cursor(Constants.OPEN_HAND_CURSOR_ICON, Input.CURSOR_ARROW, Constants.OPEN_HAND_CURSOR_ICON.get_size() / 2)


func _on_button_mouse_entered() -> void:
	mouse_inside_button = true
	if dragging_bomb:
		return
	place_delay_progress_bar.visible = false
	progress_bar_cancel = true
	if place_delay_progress_bar.visible:
		mouse_was_hidden = true
	else:
		mouse_was_hidden = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_custom_mouse_cursor(Constants.POINTER_HAND_CURSOR_ICON, Input.CURSOR_ARROW, Constants.POINTER_HAND_CURSOR_ICON.get_size() / 2)


func _on_button_mouse_exited() -> void:
	mouse_inside_button = false
	if dragging_bomb:
		return
	progress_bar_cancel = false
	if mouse_was_hidden:
		
		place_delay_progress_bar.visible = true
		
		if UiManager.active_menu == null and visible:
			print("Hiding")
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		if visible:
			Input.set_custom_mouse_cursor(Constants.OPEN_HAND_CURSOR_ICON, Input.CURSOR_ARROW, Constants.OPEN_HAND_CURSOR_ICON.get_size() / 2)
