extends Node2D

var current_orbit : int = 0

onready var orbits = [preload("res://scenes/orbits/Blank.tscn").instance(),
						preload("res://scenes/orbits/Blank.tscn").instance(),
						preload("res://scenes/orbits/TutorialPlanetAndMoon.tscn").instance(),
						preload("res://scenes/orbits/TutorialPelett.tscn").instance(),
						preload("res://scenes/orbits/Orbit1.tscn").instance(),
						preload("res://scenes/orbits/Orbit2.tscn").instance(),
						preload("res://scenes/orbits/Orbit1.tscn").instance(),
						preload("res://scenes/orbits/Orbit2.tscn").instance(),
						preload("res://scenes/orbits/Orbit1.tscn").instance(),
						preload("res://scenes/orbits/Orbit2.tscn").instance(),
						preload("res://scenes/orbits/Orbit1.tscn").instance(),
						preload("res://scenes/orbits/Orbit2.tscn").instance(),
						preload("res://scenes/orbits/Orbit1.tscn").instance(),
						preload("res://scenes/orbits/Orbit2.tscn").instance()]

const anim_orbit_up = preload("res://assets/animations/anim_orbit_up.tres")

onready var current_orbits : Array = [null, null, orbits[0], orbits[1], orbits[2]]

onready var animation_player = get_node("AnimationPlayer")

onready var player = get_node("Player")

func _ready():
	player.connect("orbit_up", self, "orbit_up")
	player.connect("orbit_down", self, "orbit_down")

	current_orbits[3].scale = Vector2(1.3, 1.3)
	current_orbits[4].scale = Vector2(1.7, 1.7)
	current_orbits[4].modulate = Color(1.0, 1.0, 1.0, 0.0)
	add_child(current_orbits[2])
	add_child(current_orbits[3])
	add_child(current_orbits[4])

func orbit_up() -> void:
	current_orbit += 1
	#remove_child(current_orbits[0])
	if current_orbits[0] != null:
		current_orbits[0].visible = false
	current_orbits[0] = current_orbits[1]
	current_orbits[1] = current_orbits[2]
	current_orbits[2] = current_orbits[3]
	current_orbits[3] = current_orbits[4]
	current_orbits[4] = get_orbit_scene_or_null(current_orbit + 2)
	if current_orbits[4] != null:
		current_orbits[4].scale = Vector2(1.7, 1.7)
		current_orbits[4].modulate = Color(1.0, 1.0, 1.0, 0.0)
		if current_orbits[4].get_parent():
			current_orbits[4].visible = true
		else:
			add_child(current_orbits[4])

	# Play animation
	if current_orbits[0] != null:
		current_orbits[0].animation_player.stop()
		current_orbits[0].animation_player.play("stage4")
	if current_orbits[1] != null:
		current_orbits[1].animation_player.stop()
		current_orbits[1].animation_player.play("stage3")
	if current_orbits[2] != null:
		current_orbits[2].animation_player.stop()
		current_orbits[2].animation_player.play("stage2")
	if current_orbits[3] != null:
		current_orbits[3].animation_player.stop()
		current_orbits[3].animation_player.play("stage1")

func orbit_down() -> void:
	current_orbit -= 1
	#remove_child(current_orbits[4])
	if current_orbits[4] != null:
		current_orbits[4].visible = false
	current_orbits[4] = current_orbits[3]
	current_orbits[3] = current_orbits[2]
	current_orbits[2] = current_orbits[1]
	current_orbits[1] = current_orbits[0]
	current_orbits[0] = get_orbit_scene_or_null(current_orbit - 2)
	if current_orbits[0] != null:
		current_orbits[0].scale = Vector2(0.55, 0.55)
		current_orbits[0].modulate = Color(1.0, 1.0, 1.0, 0.0)
		if current_orbits[0].get_parent():
			current_orbits[0].visible = true
		else:
			add_child(current_orbits[0])

	# Play animation
	if current_orbits[1] != null:
		current_orbits[1].animation_player.stop()
		current_orbits[1].animation_player.play_backwards("stage4")
	if current_orbits[2] != null:
		current_orbits[2].animation_player.stop()
		current_orbits[2].animation_player.play_backwards("stage3")
	if current_orbits[3] != null:
		current_orbits[3].animation_player.stop()
		current_orbits[3].animation_player.play_backwards("stage2")
	if current_orbits[4] != null:
		current_orbits[4].animation_player.stop()
		current_orbits[4].animation_player.play_backwards("stage1")

func get_orbit_scene_or_null(p_index : int) -> PackedScene:
	if p_index >= 0 and p_index < orbits.size():
		return orbits[p_index]
	else:
		return null

func _process(_delta : float) -> void:
	# Center on screen
	position = get_viewport_rect().size / 2.0