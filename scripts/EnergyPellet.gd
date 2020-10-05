extends Control

onready var animation_player = get_node("AnimationPlayer")
onready var label = get_node("Label")

func energy_up(p_new_value : int) -> void:
	animation_player.seek(0)
	animation_player.play("energy_up")
	set_counter(p_new_value)

func energy_down(p_new_value : int) -> void:
	animation_player.seek(0)
	animation_player.play("energy_down")
	set_counter(p_new_value)

func set_counter(p_value : int) -> void:
	label.set_text("x%02d" % p_value)