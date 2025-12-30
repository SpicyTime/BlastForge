extends Camera2D

@export var base_shake_intensity: float = 3.45
@export var shake_time: float = 0.8
@onready var shake_component: ShakeComponent = $ShakeComponent

func _ready() -> void:
	SignalManager.explosive_detonated.connect(_on_explosive_detonated)


func _on_explosive_detonated(_shapes_broken) -> void:
	var shake_intensity: float =  base_shake_intensity + StatManager.get_explosive_stat("damage") * Constants.SCALE_RATIO
	shake_intensity = min(shake_intensity, Constants.CAMERA_SHAKE_INTENSITY_CAP)
	shake_component.shake(shake_intensity, shake_time)
