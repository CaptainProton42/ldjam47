extends Node2D

export var orbital_velocity = 0.0

onready var animation_player = get_node("AnimationPlayer")
onready var orbit_line = get_node("OrbitLine2D")

var _current_scale = Vector2(1.0, 1.0)

func _ready():
	# Normalize radial distance of objects so they are on the circle
	for child in get_children():
		if child != orbit_line and child != animation_player:
			child.position = child.position.normalized() * 250

func initialize_orbit(orbit_idx : int) -> void:
	_current_scale = pow(1.3, orbit_idx) * Vector2(1.0, 1.0)
	scale = _current_scale

func _process(delta : float) -> void:
	rotation += orbital_velocity * delta

	orbit_line.modulate.a = lerp(0.5, 1.0, smoothstep(1.0 / 1.3, 1.0, scale.x) * smoothstep(1.3, 1.0, scale.x))
	modulate.a = lerp(0.0, 1.0, smoothstep(0.3, 0.5, scale.x) * smoothstep(2.0, 1.5, scale.x))

func orbit_up() -> void:
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ".:scale")
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
	animation.track_set_path(track_index, ".:scale")
	animation.track_insert_key(track_index, 0.0, _current_scale)
	animation.track_insert_key(track_index, 0.1, 1.3 * _current_scale)
	animation_player.stop()
	animation_player.remove_animation("change_size")
	animation_player.add_animation("change_size", animation)
	animation_player.play("change_size")
	_current_scale *= 1.3
