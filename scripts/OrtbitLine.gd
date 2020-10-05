tool
extends Line2D

export var subdivisions : int = 32 setget set_subdivisions, get_subdivisions
var _subdivisions : int

export var radius : float setget set_radius, get_radius
var _radius : float = 100.0

func set_subdivisions(p_subdivisions : int) -> void:
	_subdivisions = p_subdivisions
	_regenerate()

func get_subdivisions() -> int:
	return _subdivisions

func set_radius(p_radius : float) -> void:
	_radius = p_radius
	_regenerate()

func get_radius() -> float:
	return _radius

func _regenerate():
	var new_points : PoolVector2Array = PoolVector2Array()
	new_points.resize(_subdivisions + 1)

	var pi_s : float = 2.0 * PI / _subdivisions

	for s in range(_subdivisions + 1):
		var t = pi_s * s
		new_points[s] = _radius * Vector2(sin(t), cos(t))

	points = new_points
