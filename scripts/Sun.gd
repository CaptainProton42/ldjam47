extends Node2D

var _current_scale : Vector2 = Vector2(1.0, 1.0)
var _expanding : bool = false
var _expansion_scale : Vector2 = Vector2(1.0, 1.0)

export var scale_without_expansion : Vector2 = Vector2(1.0, 1.0)

var size : float = -3.0

onready var animation_player = get_node("AnimationPlayer")

func orbit_up() -> void:
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ".:scale_without_expansion")
	animation.track_insert_key(track_index, 0.0, _current_scale)
	animation.track_insert_key(track_index, 0.1, _current_scale / 1.3)
	animation_player.stop()
	animation_player.remove_animation("change_size")
	animation_player.add_animation("change_size", animation)
	animation_player.play("change_size")
	_current_scale /= 1.3

func orbit_down() -> void:
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ".:scale_without_expansion")
	animation.track_insert_key(track_index, 0.0, _current_scale)
	animation.track_insert_key(track_index, 0.1, 1.3 * _current_scale)
	animation_player.stop()
	animation_player.remove_animation("change_size")
	animation_player.add_animation("change_size", animation)
	animation_player.play("change_size")
	_current_scale *= 1.3

func trigger() -> void:
	_expanding = true

func _ready():
	_expansion_scale = pow(1.3, size) * Vector2(1.0, 1.0)
	scale = scale_without_expansion * _expansion_scale

func _process(delta : float) -> void:
	if _expanding:
		if size < 0.0:
			size += delta * 0.5
		else:
			size += delta * 0.3
		_expansion_scale = pow(1.3, size) * Vector2(1.0, 1.0)
	scale = scale_without_expansion * _expansion_scale