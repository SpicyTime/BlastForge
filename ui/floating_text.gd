extends Marker2D
var exist_time: float = 0.0

func _ready() -> void:
	var pos_tween: Tween = get_tree().create_tween()
	pos_tween.tween_property(self, "position", position + Vector2(0.0, -20.0), exist_time)
	var transparency_tween: Tween = get_tree().create_tween()
	transparency_tween.tween_property(self, "modulate:a", 0.3, exist_time)
