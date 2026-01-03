extends Control
@export var base_shake_intensity: float = 2.0
@onready var points_label: Label = $InfoBox/PointsLabel
@onready var place_delay_label: Label = $InfoBox/PlaceDelayLabel
var is_handling_unsuccessful_place: bool = false
func _ready() -> void:
	SignalManager.points_changed.connect(func(new_value: int) -> void: points_label.text = str(new_value))
	SignalManager.bomb_detonated.connect(_on_bomb_detonated)
	SignalManager.purchase_amount_changed.connect(func(amount: int) -> void:
		if amount > 0:
			$Button/PlusSignRect.visible = true
		else:
			$Button/PlusSignRect.visible = false
		)
	SignalManager.place_delay_timer_changed.connect(func(value: float) -> void:
		if value > 0.0:
			place_delay_label.text = str(value)
		else:
			place_delay_label.text = ""
		)
	SignalManager.unsuccessful_bomb_place.connect(_on_unsuccessful_bomb_place)


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
	var base_font_size: int = place_delay_label.get("theme_override_font_sizes/font_size")
	var base_color: Color = Color(1, 1, 1)
	var base_rotation: float = place_delay_label.rotation_degrees
	var final_font_size: int = 60
	var final_rotation_degrees: float 
	var final_color: Color = Color(1, 0, 0)
	var tween_time: float = 0.06
	var hold_time: float = 0.16
	var scale_up_tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	scale_up_tween.tween_property(place_delay_label, "theme_override_font_sizes/font_size", final_font_size, tween_time)
	place_delay_label.add_theme_color_override(
		"font_color",
		final_color
	)
	await scale_up_tween.finished
	await get_tree().create_timer(hold_time).timeout
	var scale_down_tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	scale_down_tween.tween_property(place_delay_label, "theme_override_font_sizes/font_size", base_font_size, tween_time)
	place_delay_label.add_theme_color_override(
		"font_color",
		base_color
	)
	await scale_down_tween.finished
	is_handling_unsuccessful_place = false
	#region
	#place_delay_label.add_theme_font_size_override(
	#	"font_size",
	#	final_font_size
	#)
	#
	#place_delay_label.add_theme_color_override(
	#	"font_color",
	#	final_color
	#)
	#await get_tree().create_timer(tween_time).timeout
	#is_handling_unsuccessful_place = false
	## Returns the values to the base
	#place_delay_label.add_theme_font_size_override(
	#	"font_size",
	#	base_font_size
	#)
	#
	#place_delay_label.add_theme_color_override(
	#	"font_color",
	#	base_color
	#)
	#
	#endregion
