extends CharacterBody2D

signal take_damage(damage : int)
signal health_reset()

const SPEED : int = 3
const DEFAULT_FRAMES  : int = 60

var ghost : bool = false
var can_move : bool = true
var current_spawn : Vector2
var last_direction : Vector2 = Vector2(0,-1)

@onready var anim_sprite : AnimatedSprite2D = $CanvasLayer/Control/AnimatedSprite2D
@onready var player_canvas : CanvasLayer = $CanvasLayer

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
func on_player_hit(damage : int) -> void:
	take_damage.emit(damage)
	
func player_reset(ghost_death : bool) -> void:
	anim_sprite.self_modulate = Color(1,1,1,1)
	ghost = false
	if ghost_death:
		player_canvas.layer = 4
		anim_sprite.play("ghost_death")

func player_death() -> void:
	if ghost:
		player_reset(true)
		return
	ghost = true
	anim_sprite.play("death")

func respawn_player(new_spawn : Vector2 = current_spawn):
	health_reset.emit()
	if ghost:
		anim_sprite.self_modulate = Color(1,1,1,0.6)
	else:
		anim_sprite.self_modulate = Color(1,1,1,1)
	anim_sprite.play("player_down_idle")
	self.position = current_spawn
	current_spawn = new_spawn

func player_ressurection(pos : Vector2) -> void:
	anim_sprite.self_modulate = Color(1,1,1,1)
	self.position = pos
	current_spawn = pos
	get_parent().get_tree().paused = true
	can_move = false
	ghost = false
	
	anim_sprite.play("ressurection")
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
