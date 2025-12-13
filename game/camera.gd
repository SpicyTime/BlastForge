extends Camera2D

@export var shake_intensity: int = 3
@export var shake_time: float = 0.6
@onready var shake_component: ShakeComponent = $ShakeComponent

func _ready() -> void:
	SignalManager.explosive_detonated.connect(_on_explosive_detonated)


func _on_explosive_detonated(_breakables_broken) -> void:
	shake_component.shake(shake_intensity, shake_time)
