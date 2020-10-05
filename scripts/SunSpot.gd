tool
extends Sprite

export var amplitude : float = 0.1
export var frequency : float = 2.0
export var base_scale : float = 0.5

var _time : float = 0.0


func _process(delta : float) -> void:
	_time += delta
	scale = Vector2(1.0, 1.0) * base_scale * (1.0 + amplitude + amplitude * sin(frequency * _time))