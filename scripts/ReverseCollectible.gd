extends Collectible

func _ready():
	get_node("CollisionShape2D/Sprite/AnimationPlayer").play("swirl")
