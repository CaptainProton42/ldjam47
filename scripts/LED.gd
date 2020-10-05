extends Control

onready var animation_player = get_node("AnimationPlayer")

func _ready() -> void:
	animation_player.play("blink")