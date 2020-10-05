extends Node2D

onready var animation_player = get_node("AnimationPlayer")

func _process(_delta : float) -> void:
	# Center on screen
	position = get_viewport_rect().size / 2.0