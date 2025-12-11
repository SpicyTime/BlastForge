extends Area2D
@export var is_side: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Breakable:
		body = body as Breakable
		if is_side:
			body.move_direction.x *= -1
		else:
			body.move_direction.y *= -1
