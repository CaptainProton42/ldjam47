extends Area2D

enum DefeatReason {
	CRASHED,
	BURNED
}

signal defeated
signal escaped
signal orbit_up
signal orbit_down
signal energy_pellet_collected
signal grav_anomaly_collected
signal reverse_collected
signal energy_up
signal energy_down

export var initial_radial_velocity : float = 0.5

onready var animation_player = get_node("AnimationPlayer")
onready var animation_player_collect = get_node("AnimationPlayerCollect")
onready var animation_player_explode = get_node("AnimationPlayerExplode")
onready var audio = get_node("AudioStreamPlayer")
onready var sprite = get_node("Sprite")
onready var touch_area = get_node("TouchControls/TouchArea")

export var level_container_path : NodePath
onready var level_container = get_node(level_container_path)
onready var game = get_tree().get_root().get_child(0)

var _phi : float
var _direction : int = 1
export var radial_velocity : float = 0.0 # so it can be edited by animation node
var energy_pellets : int
var current_orbit : int = 0

var is_defeated : bool = false
var has_escaped : bool = false

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	touch_area.connect("input_event", self, "_on_touch_area_input")
	game.connect("game_state_changed", self, "_on_game_state_changed")
	reset()

func reset() -> void:
	animation_player.stop()
	sprite.scale = Vector2(0.12, 0.12)
	sprite.offset = Vector2(0.0, 0.0)
	rotation = 0.0
	_phi = 0.0
	_direction = 1
	radial_velocity = initial_radial_velocity
	current_orbit = 0
	is_defeated = false
	has_escaped = false
	visible = true
	scale = Vector2(1.0, 1.0)
	sprite.visible = true

func _process(delta : float) -> void:
	touch_area.position = get_viewport_rect().size / 2.0

	if game.game_state == game.GameState.LEVEL:
		if Input.is_action_just_pressed("orbit_up"):
			orbit_up()
		elif Input.is_action_just_pressed("orbit_down"):
			orbit_down()

	if game.game_state == game.GameState.LEVEL or game.game_state == game.GameState.CLEARED:
		_phi += _direction * radial_velocity * delta
		position = 250.0 * Vector2(sin(_phi), cos(_phi))
		rotation = PI - _phi

func _on_area_entered(p_area : Area2D) -> void:
	if game.game_state == game.GameState.LEVEL and not has_escaped:
		match p_area.collision_layer:
			2:
				is_defeated = true
				animation_player_explode.play("explode")
				emit_signal("defeated", DefeatReason.CRASHED)
			4:
				match p_area.type:
					p_area.CollectibleType.ENERGY_PELLET:
						energy_pellets += 1
						emit_signal("energy_pellet_collected")
						emit_signal("energy_up", energy_pellets)
						animation_player_collect.play("energy_pellet_collected")
						p_area.collect()
					p_area.CollectibleType.GRAV_ANOMALY:
						emit_signal("grav_anomaly_collected")
						p_area.collect()
					p_area.CollectibleType.REVERSE:
						emit_signal("reverse_collected")
						p_area.collect()
						_direction = -_direction
						scale.x = -scale.x
			8:
				is_defeated = true
				animation_player_explode.play("explode")
				emit_signal("defeated", DefeatReason.BURNED)

func orbit_up() -> void:
	if game.game_state == game.GameState.LEVEL:
		if energy_pellets > 0 or game.game_modifier == game.GameModifier.GRAV_ANOMALY:
			if current_orbit < level_container.get_child(0).orbits.size() - 1:
				current_orbit += 1
				if game.game_modifier != game.GameModifier.GRAV_ANOMALY:
					energy_pellets -= 1
					emit_signal("energy_down", energy_pellets)
				emit_signal("orbit_up")
				animation_player.stop()
				animation_player.play("orbit_up")
			else:
				has_escaped = true
				emit_signal("escaped")

func orbit_down() -> void:
	if game.game_state == game.GameState.LEVEL:
		if current_orbit > 0:
			current_orbit -= 1
			if game.game_modifier != game.GameModifier.GRAV_ANOMALY:
				energy_pellets += 1
				emit_signal("energy_up", energy_pellets)
			emit_signal("orbit_down")
			animation_player.stop()
			animation_player.play("orbit_down")

func _on_touch_area_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if (event.position - get_viewport_rect().size / 2.0).x > 0.0:
			orbit_up()
		else:
			orbit_down()
			
func _on_game_state_changed(game_state : int):
	match game_state:
		game.GameState.LEVEL:
			reset()
		game.GameState.CLEARED:
			animation_player.stop()
			animation_player.play("escape")
		game.GameState.TITLE:
			visible = false
		game.GameState.GAME_OVER:
			pass
