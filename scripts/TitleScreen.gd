extends Control

signal start_selected

onready var animation_player = get_node("AnimationPlayer")
onready var start_button = get_node("StartButton")
onready var quit_button = get_node("QuitButton")

func _ready():
	start_button.connect("pressed", self, "_on_start_pressed")
	quit_button.connect("pressed", self, "_on_quit_pressed")

func open():
	animation_player.play("open")
	visible = true
	start_button.grab_focus()

func close():
	animation_player.play_backwards("open")
	yield(animation_player, "animation_finished")
	visible = false

func _on_start_pressed():
	emit_signal("start_selected")
	close()

func _on_quit_pressed():
	get_tree().quit()