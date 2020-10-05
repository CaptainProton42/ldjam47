extends Control

signal continue_selected

onready var animation_player = get_node("AnimationPlayer")
onready var continue_button = get_node("ContinueButton")

func _ready():
	continue_button.connect("pressed", self, "_on_continue_pressed")

func open():
	animation_player.play("open")
	visible = true
	continue_button.grab_focus()

func close():
	animation_player.play_backwards("open")
	yield(animation_player, "animation_finished")
	visible = false

func _on_continue_pressed():
	emit_signal("continue_selected")
	close()