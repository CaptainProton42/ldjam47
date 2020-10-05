tool
extends TextureButton

export var text : String = "" setget set_text, get_text
var _text : String
export var anim_speed : float = 5.0
export var anim_amplitude : float = 1.0
export var base_scale : float = 0.5

var _time : float = 0.0

var _audio_lock : bool = false

onready var animation_player = get_node("AnimationPlayer")
onready var audio = get_node("AudioStreamPlayer")

func _ready() -> void:
	connect("focus_entered", self, "_on_focus_entered")
	connect("focus_exited", self, "_on_focus_exited")
	connect("button_down", self, "_on_button_down")
	connect("button_up", self, "_on_button_up")
	connect("pressed", self, "_on_pressed")

	connect("mouse_entered", self, "grab_focus")

	set_text(_text)

# prevent audio from being played when grabbing focus from code
func grab_focus():
	_audio_lock = true
	.grab_focus()

func _process(delta : float) -> void:
	_time += anim_speed * delta
	rect_rotation = 5.0 * anim_amplitude * sin(_time)
	rect_scale = base_scale * (1.0 + 0.05 * anim_amplitude * sin(1.8 * _time)) * Vector2(1.0, 1.0)
	rect_pivot_offset = rect_size / 2.0

func _on_focus_entered() -> void:
	if not _audio_lock:
		audio.play()
	else:
		_audio_lock = false
	animation_player.play("mouseover")

func _on_focus_exited() -> void:
	animation_player.play_backwards("mouseover")

func set_text(p_text : String) -> void:
	_text = p_text
	if is_inside_tree():
		get_node("Label").set_text(p_text)

func get_text() -> String:
	return _text

func _on_button_down() -> void:
	get_node("Label").rect_position.y += 25

func _on_button_up() -> void:
	get_node("Label").rect_position.y -= 25

func _on_pressed() -> void:
	audio.play()
