extends Node
var music_node: AudioStreamPlayer2D = null
func play_sfx(stream: AudioStream, volume: float = 0.0, is_pitch_shifted: bool = false, shift_scale: Vector2 = Vector2(0.9, 1.1)) -> void:
	var pitch: float = 1.0
	if is_pitch_shifted:
		pitch = _get_pitch_shift(shift_scale.x, shift_scale.y)
	var sfx_player: AudioStreamPlayer2D = _create_sfx_player(stream, volume, pitch)
	var audio_holder: Node = get_tree().root.find_child("Main").find_child("AudioHolder")
	audio_holder.add_child(sfx_player)
	await sfx_player.tree_entered
	sfx_player.play()
	await sfx_player.finished
	sfx_player.queue_free()


func set_music_node(node: AudioStreamPlayer2D) -> void:
	music_node = node


func start_music(stream: AudioStream) -> void:
	music_node.stream = stream
	music_node.play()


func end_music() -> void:
	music_node.playing = false


func fade_in_music() -> void:
	pass


func fade_out_music() -> void:
	pass


func _create_sfx_player(stream: AudioStream,volume: float, pitch: float) -> AudioStreamPlayer2D:
	var sfx_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	sfx_player.pitch_scale = pitch
	sfx_player.volume_db = volume
	sfx_player.stream = stream
	return sfx_player


func _get_pitch_shift(min_pitch: float, max_pitch) -> float:
	return  randi_range(min_pitch, max_pitch)
