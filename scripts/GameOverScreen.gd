extends FullScreenControl

signal retry_selected
signal back_to_title_selected

onready var animation_player = get_node("AnimationPlayer")
onready var button_back_to_title = get_node("Buttons/BackToTitle")
onready var button_retry = get_node("Buttons/Retry")
onready var warning_message = get_node("WarningMessage")

func _ready() -> void:
	visible = false
	button_back_to_title.connect("pressed", self, "_on_back_to_title")
	button_retry.connect("pressed", self, "_on_retry")

func open(defeat_reason : int) -> void:
	match defeat_reason:
		0:
			warning_message.text = "CRASHED!"
		1:
			warning_message.text = "BURNED!"
	animation_player.play("open")
	visible = true
	button_retry.grab_focus()

func close() -> void:
	animation_player.play_backwards("open")
	yield(animation_player, "animation_finished")
	visible = false

func _on_back_to_title() -> void:
	emit_signal("back_to_title_selected")
	close()

func _on_retry() -> void:
	emit_signal("retry_selected")
	close()
