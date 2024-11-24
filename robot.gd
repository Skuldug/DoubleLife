extends BasicMonster

@onready var anim_sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	# If there is movement (non-zero velocity), update the animation
	if velocity.x < 0:  # Moving left
		if anim_sprite.animation != "robot_right" or !anim_sprite.flip_h:
			anim_sprite.flip_h = true
			anim_sprite.play("robot_right")
	elif velocity.x > 0:  # Moving right
		if anim_sprite.animation != "robot_right" or anim_sprite.flip_h:
			anim_sprite.flip_h = false
			anim_sprite.play("robot_right")
	elif velocity.y > 0:  # Moving down
		if anim_sprite.animation != "robot_down":
			anim_sprite.play("robot_down")
	elif velocity.y < 0:  # Moving up
		if anim_sprite.animation != "robot_up":
			anim_sprite.play("robot_up")
