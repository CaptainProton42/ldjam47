class_name Collectible
extends Area2D

enum CollectibleType {
	ENERGY_PELLET,
	GRAV_ANOMALY,
	REVERSE
}

export(CollectibleType) var type : int

onready var animation_player = get_node("AnimationPlayer")

func _ready():
	animation_player.play("idle")
	rotation = randf() * 2.0 * PI

func _process(delta):
	rotation += delta

func collect():
	set_deferred("monitorable", false)
	animation_player.play("collect")
	yield(animation_player, "animation_finished")
	queue_free()