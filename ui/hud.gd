extends Control
@export var base_shake_intensity: float = 2.0
@onready var points_label: Label = $PointsLabel

func _ready() -> void:
	SignalManager.points_changed.connect(func(new_value: int) -> void:
		points_label.text = str(new_value)
		)
	SignalManager.explosive_detonated.connect(_on_explosive_detonated)
	SignalManager.purchase_amount_changed.connect(func(amount: int) -> void:
		if amount > 0:
			$Button/PlusSignRect.visible = true
		else:
			$Button/PlusSignRect.visible = false
		)


func _on_button_pressed() -> void:
	UiManager.swap_menu("UpgradeHub")
	UiManager.hide_overlay("Hud")


func _on_explosive_detonated(_shapes_broken: Array[Node2D]) -> void:
	var shake_intensity: float = base_shake_intensity + StatManager.get_explosive_stat("damage") * Constants.SCALE_RATIO
	shake_intensity = min(shake_intensity, Constants.UI_SHAKE_INTENSITY_CAP)
	$ShakeComponent.shake(shake_intensity, 0.8)
