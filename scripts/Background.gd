extends ColorRect

onready var animation_player = get_node("AnimationPlayer")
onready var particles_grav_anomaly = get_node("ParticlesGravAnomaly")

export var player_path : NodePath
onready var player = get_node(player_path)
onready var game = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("orbit_up", self, "_on_orbit_up")
	player.connect("orbit_down", self, "_on_orbit_down")

	game.connect("game_modifier_changed", self, "_on_game_modifier_changed")
	game.connect("game_state_changed", self, "_on_game_state_changed")

func _on_orbit_up() -> void:
	animation_player.stop()
	animation_player.play("orbit_up")

func _on_orbit_down() -> void:
	animation_player.stop()
	animation_player.play("orbit_down")

func _process(_delta : float) -> void:
	rect_size = get_viewport_rect().size

func _on_game_modifier_changed(game_modifier : int) -> void:
	match game_modifier:
		game.GameModifier.GRAV_ANOMALY:
			particles_grav_anomaly.get_node("AnimationPlayer").play("fade_in")
		game.GameModifier.NONE:
			particles_grav_anomaly.get_node("AnimationPlayer").play_backwards("fade_in")

func _on_game_state_changed(game_state : int) -> void:
	match game_state:
		game.GameState.TITLE:
			animation_player.play_backwards("escape")			
		game.GameState.CLEARED:
			animation_player.play("escape")