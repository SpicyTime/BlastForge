extends Node2D

func _ready() -> void:
	SignalManager.spawn_particles.connect(_on_spawn_particle_request)


func _on_spawn_particle_request(path: String, spawn_position: Vector2, delay: float = 0.0) -> void:
	var particle_node: GPUParticles2D = load(path).instantiate()
	particle_node.position = spawn_position
	await get_tree().create_timer(delay).timeout
	add_child(particle_node)
	particle_node.emitting = true
	await particle_node.finished
	particle_node.queue_free()
