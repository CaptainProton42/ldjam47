tool
extends Area2D

enum PlanetType {
	GIANT,
	MOON
}

const planet_textures = { PlanetType.GIANT:  preload("res://assets/textures/giant.png"),
						  PlanetType.MOON: preload("res://assets/textures/moon.png") }

export var color : Color = Color(1.0, 1.0, 1.0) setget set_color, get_color
var _color : Color
export var size : float = 1.0 setget set_size, get_size
var _size : float
export(PlanetType) var type : int = PlanetType.GIANT setget set_type, get_type
var _type : int

onready var sprite = get_node("Sprite")
onready var shadow = get_node("Shadow")
onready var collision_shape = get_node("CollisionShape2D")

func set_color(p_color : Color) -> void:
	_color = p_color
	generate()

func get_color() -> Color:
	return _color

func set_size(p_size : float) -> void:
	_size = p_size
	generate()

func get_size() -> float:
	return _size

func set_type(p_type : int) -> void:
	_type = p_type
	generate()

func get_type() -> int:
	return _type

func generate():
	if is_inside_tree():
		scale = Vector2(_size, _size)
		sprite.self_modulate = _color
		sprite.set_texture(planet_textures[_type])

func _ready():
	generate()
