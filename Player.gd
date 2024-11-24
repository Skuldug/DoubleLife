extends CharacterBody2D

signal take_damage(damage : int)
signal health_reset()

const SPEED = 3
const DEFAULT_FRAMES = 60

var ghost = false
var can_move = true
var current_spawn : Vector2
var last_direction : Vector2 = Vector2(0,-1)

@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Get input from user
	if !can_move:
		return
	var x_direction := Input.get_axis("player_left", "player_right")
	var y_direction := Input.get_axis("player_up", "player_down")
	
	# Set velocity
	velocity = Vector2(x_direction, y_direction).normalized() * SPEED * DEFAULT_FRAMES * delta
	move_and_collide(velocity)
	
	
	# Update the last direction (only if there's movement)
	if velocity != Vector2.ZERO:
		last_direction = velocity
	
	# Handle animation based on velocity and last direction
	handle_animation(velocity)
func _on_player_hit(damage : int) -> void:
	take_damage.emit(damage)
	
func player_reset() -> void:
	ghost = false
	health_reset.emit()
	

func player_death(new_spawn : Vector2 = current_spawn) -> void:
	if ghost:
		ghost = false
		return
	anim_sprite.play("death")
	can_move = false
	await anim_sprite.animation_finished
	can_move = true
	ghost = true
	self.position = current_spawn
	current_spawn = new_spawn
	health_reset.emit()

func player_ressurection(pos : Vector2) -> void:
	self.position = pos
	current_spawn = pos
	anim_sprite.play("ressurection")
	can_move = false
	await anim_sprite.animation_finished
	can_move = true
	ghost = false
	health_reset.emit()
# Handle animation based on movement and idle states
func handle_animation(velocity: Vector2) -> void:
	# If there is movement (non-zero velocity), update the animation
	if velocity.x < 0:  # Moving left
		anim_sprite.flip_h = false
		if anim_sprite.animation != "player_left":
			anim_sprite.play("player_left")
	elif velocity.x > 0:  # Moving right
		anim_sprite.flip_h = true
		if anim_sprite.animation != "player_left":
			anim_sprite.play("player_left")
	elif velocity.y > 0:  # Moving down
		if anim_sprite.animation != "player_down":
			anim_sprite.flip_h = false
			anim_sprite.play("player_down")
	elif velocity.y < 0:  # Moving up
		if anim_sprite.animation != "player_up":
			anim_sprite.flip_h = false
			anim_sprite.play("player_up")
	
	# If idle, set to appropriate idle animation based on last direction
	elif velocity == Vector2.ZERO:
		if last_direction.x < 0:  # Idle facing left
			anim_sprite.flip_h = false
			if anim_sprite.animation != "player_left_idle":
				anim_sprite.play("player_left_idle")
		elif last_direction.x > 0:  # Idle facing right
			anim_sprite.flip_h = true
			if anim_sprite.animation != "player_left_idle":
				anim_sprite.play("player_left_idle")
		elif last_direction.y > 0:  # Idle facing down
			if anim_sprite.animation != "player_down_idle":
				anim_sprite.play("player_down_idle")
		elif last_direction.y < 0:  # Idle facing up
			if anim_sprite.animation != "player_up_idle":
				anim_sprite.play("player_up_idle")
