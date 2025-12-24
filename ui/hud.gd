extends Control
@onready var points_label: Label = $PointsLabel

func _ready() -> void:
	SignalManager.points_changed.connect(func(new_value: int) -> void:
		points_label.text = str(new_value)
		)


func _on_button_pressed() -> void:
	UiManager.swap_menu("ShapeUpgradeHub")
	UiManager.hide_overlay("Hud")
