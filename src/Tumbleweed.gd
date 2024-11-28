extends BasicMonster

@onready var anim_sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	# If there is movement (non-zero velocity), update the animation
	if velocity.x < 0:  # Moving left
		if anim_sprite.animation != "tumble_left" or anim_sprite.flip_h:
			anim_sprite.set_flip_h(true)
			anim_sprite.play("tumble_left")
	elif velocity.x > 0:  # Moving right
		if anim_sprite.animation != "tumble_left" or !anim_sprite.flip_h:
			anim_sprite.set_flip_h(false)
			anim_sprite.play("tumble_left")
	elif !velocity.y and !velocity.x and anim_sprite.animation != "tumble_idle":
		anim_sprite.play("tumble_idle")  # Moving down
		
