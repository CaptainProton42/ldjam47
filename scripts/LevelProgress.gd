extends Control

onready var animation_player = get_node("AnimationPlayer")
onready var progress_bar = get_node("ProgressBar")
onready var label = get_node("ProgressBar/Label")

var _shake_amplitude : float = 0.0

var _time : float = 0.0

func update_progress(new_value : float) -> void:
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "ProgressBar:value")
	animation.track_insert_key(track_index, 0.0, progress_bar.value)
	animation.track_insert_key(track_index, 0.1, new_value)
	animation_player.stop()
	animation_player.remove_animation("update")
	animation_player.add_animation("update", animation)
	animation_player.play("update")
	_shake_amplitude = max(0.0, lerp(-1.0, 1.0, new_value / 100.0))
	if _shake_amplitude < 1.0:
		progress_bar.material.set_shader_param("brightness", 0.0)

func _process(delta : float):
	if _shake_amplitude < 1.0:
		label.text = "ESCAPE VELOCITY: %02.1f%%" % progress_bar.value
	elif get_parent().player.energy_pellets > 0:
		label.text = "ESCAPE VELOCITY: 100%"
	else:
		label.text = "ESCAPE VELOCITY: 99.9%"

	_time += delta
	# Shake effect
	progress_bar.rect_position = _shake_amplitude * 5.0 * Vector2(sin(20.0*_time), sin(30.0 * _time + 1.0))
	progress_bar.rect_rotation = _shake_amplitude * 1.0 * sin(25.0 * _time)
	if _shake_amplitude == 1.0 and get_parent().player.energy_pellets > 0:
		progress_bar.material.set_shader_param("brightness", 0.3 + 0.3 * sin(8.0 * _time))