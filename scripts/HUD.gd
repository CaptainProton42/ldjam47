extends Control

onready var energy_pellet = get_node("EnergyPellet")
onready var animation_player = get_node("AnimationPlayer")
onready var level_progress = get_node("LevelProgress")

export var player_path : NodePath
export var level_container_path : NodePath

onready var player = get_node(player_path)
onready var level_container = get_node(level_container_path)

var shake_amplitude : float = 0.0

var _time : float = 0.0

var running : bool = false

func _ready():
	player.connect("energy_up", energy_pellet, "energy_up")
	player.connect("energy_down", energy_pellet, "energy_down")

	player.connect("orbit_up", self, "_on_orbit_up")
	player.connect("orbit_down", self, "_on_orbit_down")
	player.connect("energy_pellet_collected", self, "shake")
	player.connect("grav_anomaly_collected", self, "shake")

func reset() -> void:
	running = true
	energy_pellet.set_counter(player.energy_pellets)
	level_progress.update_progress(0.0)

func _on_orbit_up() -> void:
	animation_player.stop()
	animation_player.play("orbit_up")
	level_progress.update_progress(level_container.get_child(0).get_progress())

func _on_orbit_down() -> void:
	animation_player.stop()
	animation_player.play("orbit_down")
	level_progress.update_progress(level_container.get_child(0).get_progress())

func shake() -> void:
	animation_player.stop()
	animation_player.play("shake")

func _process(delta : float) -> void:
	# Shake close to the sun
	if running:
		_time += delta
		shake_amplitude = 5.0 * smoothstep(2.0, 0.0, player.current_orbit - level_container.get_child(0).sun.size)
		rect_position.x = shake_amplitude * sin(35.0 * _time)
		rect_position.y = shake_amplitude * sin(30.0 * _time + 1.0)
