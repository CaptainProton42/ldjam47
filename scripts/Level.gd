class_name Level
extends Node2D

export var sun_trigger_orbit : int = 2
export var initial_energy : int = 0

export(Array, String, FILE) var orbit_files = []
var orbits = []

const anim_orbit_up = preload("res://assets/animations/anim_orbit_up.tres")

onready var animation_player = get_node("AnimationPlayer")

onready var player = get_node("../../Player")
onready var orbit_container = get_node("Orbits")
onready var sun = get_node("Sun")
onready var game = get_tree().get_root().get_child(0)

func _ready():
	orbits.resize(orbit_files.size())

	player.connect("orbit_up", self, "orbit_up")
	player.connect("orbit_down", self, "orbit_down")

	game.connect("game_modifier_changed", self, "_on_game_modifier_changed")

	player.energy_pellets = initial_energy

	for i in range(orbits.size()):
		orbits[i] = load(orbit_files[i]).instance()
		orbits[i].initialize_orbit(i)
		orbit_container.add_child(orbits[i])

func orbit_up() -> void:
	sun.orbit_up()
	for o in orbits:
		o.orbit_up()
	if player.current_orbit == sun_trigger_orbit:
		sun.trigger()

func orbit_down() -> void:
	sun.orbit_down()
	for o in orbits:
		o.orbit_down()

func get_orbit_scene_or_null(p_index : int) -> PackedScene:
	if p_index >= 0 and p_index < orbits.size():
		return orbits[p_index]
	else:
		return null

func get_progress() -> float:
	return float(player.current_orbit) / float(orbits.size() - 1) * 100.0

func _on_game_modifier_changed(game_modifier : int) -> void:
	match game_modifier:
		game.GameModifier.GRAV_ANOMALY:
			animation_player.play("grav_anomaly")
		game.GameModifier.NONE:
			animation_player.play_backwards("grav_anomaly")
