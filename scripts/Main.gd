extends Node2D

enum GameState {
	TITLE,
	LEVEL,
	CLEARED,
	GAME_OVER
}

enum GameModifier {
	NONE,
	GRAV_ANOMALY
}

var game_state : int = GameState.TITLE
var game_modifier : int = GameModifier.NONE

signal game_state_changed
signal game_modifier_changed

export var player_path : NodePath
export var level_container_path : NodePath
export var hud_path : NodePath
export var game_over_screen_path : NodePath
export var clear_screen_path : NodePath
export var title_screen_path : NodePath

export var grav_anomaly_duration : float = 1.5
var _grav_anomaly_timer : float = 0.0

onready var player = get_node(player_path)
onready var level_container = get_node(level_container_path)
onready var hud = get_node(hud_path)
onready var game_over_screen = get_node(game_over_screen_path)
onready var clear_screen = get_node(clear_screen_path)
onready var title_screen = get_node(title_screen_path)

onready var background = get_node("Background")

var levels = [preload("res://scenes/levels/LevelTutorial.tscn"),
			  preload("res://scenes/levels/Level2.tscn"),
			  preload("res://scenes/levels/Level3.tscn"),
			  preload("res://scenes/levels/Level4.tscn"),
			  preload("res://scenes/levels/Level5.tscn"),
			  preload("res://scenes/levels/Level6.tscn")]

var _current_level : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("defeated", self, "_on_player_defeated")
	player.connect("escaped", self, "_on_player_escaped")

	player.connect("grav_anomaly_collected", self, "_set_game_modifier", [GameModifier.GRAV_ANOMALY])

	game_over_screen.connect("retry_selected", self, "reset_game")
	game_over_screen.connect("back_to_title_selected", self, "open_title")
	title_screen.connect("start_selected", self, "start_game")
	clear_screen.connect("continue_selected", self, "_on_continue")

	open_title()

func reset_game():
	_enter_game_state(GameState.LEVEL)
	if level_container.get_child_count() > 0:
		level_container.get_child(0).queue_free()
	level_container.add_child(levels[_current_level].instance())
	hud.reset()
	get_node("Label").text = "LEVEL %d" % (_current_level + 1)
	get_node("Label/AnimationPlayer").play("display")

func _on_player_defeated(defeat_reason : int) -> void:
	_enter_game_state(GameState.GAME_OVER)
	yield(get_tree().create_timer(0.5), "timeout")
	game_over_screen.open(defeat_reason)

func _on_player_escaped() -> void:
	_enter_game_state(GameState.CLEARED)
	level_container.get_parent().animation_player.play("escape")
	hud.animation_player.play("escape")
	yield(get_tree().create_timer(3.0), "timeout")
	clear_screen.open()

func _on_continue() -> void:
	if _current_level < levels.size() - 1:
		_current_level += 1
		reset_game()
		level_container.get_parent().animation_player.play("start")
		hud.animation_player.play_backwards("escape")
		background.animation_player.play_backwards("escape")
	else:
		open_title()

func open_title():
	level_container.visible = false
	hud.visible = false
	_enter_game_state(GameState.TITLE)
	title_screen.open()

func start_game():
	_current_level = 0
	reset_game()
	level_container.get_parent().animation_player.play("start")
	hud.animation_player.play_backwards("escape")
	hud.visible = true
	level_container.visible = true
	
func _enter_game_state(new_state : int):
	game_state = new_state
	emit_signal("game_state_changed", game_state)

func _set_game_modifier(new_modifier : int):
	game_modifier = new_modifier
	emit_signal("game_modifier_changed", game_modifier)

	match game_modifier:
		GameModifier.NONE:
			pass
		GameModifier.GRAV_ANOMALY:
			_grav_anomaly_timer = grav_anomaly_duration

func _process(delta : float):
	if game_modifier == GameModifier.GRAV_ANOMALY:
		_grav_anomaly_timer -= delta
		if _grav_anomaly_timer <= 0.0:
			_set_game_modifier(GameModifier.NONE)
