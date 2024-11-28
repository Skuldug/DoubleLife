extends BasicMonster

@onready var anim_sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	# If there is movement (non-zero velocity), update the animation
	
	if velocity.x < 0:  # Moving left
		if anim_sprite.animation != "glad_walk_left":
			anim_sprite.play("glad_walk_left")
	elif velocity.x > 0:  # Moving right
		if anim_sprite.animation != "glad_walk_right":
			anim_sprite.play("glad_walk_right")
	elif velocity.y > 0:  # Moving down
		if anim_sprite.animation != "glad_walk_down":
			anim_sprite.play("glad_walk_down")
	elif velocity.y < 0:  # Moving up
		if anim_sprite.animation != "glad_walk_up":
			anim_sprite.play("glad_walk_up")
