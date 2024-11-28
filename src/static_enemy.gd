extends Node2D

@export var detection_distance: float = 200.0  # Detection range
@export var fire_interval: float = 1.5        # Time between shots
@export var projectile: PackedScene            # The scene for the bullet

@onready var sprite = $AnimatedSprite2D        # Reference to the AnimatedSprite2D
@onready var left_cast = %left_cast             # Left RayCast2D node
@onready var right_cast = %right_cast           # Right RayCast2D node

var is_facing_left: bool = false               # Determines if facing left
var time_since_last_shot: float = 0.0          # Timer to manage shooting cooldown

func _ready():
	# Start with the idle animation
	sprite.play("idle")
	left_cast.enabled = true
	right_cast.enabled = true

func _process(delta: float) -> void:
	# Update the time tracker for the cooldown
	time_since_last_shot += delta
	check_for_target()

func check_for_target():
	# Update RayCast positions
	left_cast.target_position = Vector2(-detection_distance, 0)
	right_cast.target_position = Vector2(detection_distance, 0)

	# Perform raycast checks
	left_cast.force_raycast_update()
	right_cast.force_raycast_update()

	if left_cast.is_colliding():
		var target = left_cast.get_collider()
		if target and target.is_in_group("Player"):
			is_facing_left = true
			sprite.play("shoot_left")
			attempt_shoot()
	elif right_cast.is_colliding():
		var target = right_cast.get_collider()
		if target and target.is_in_group("Player"):
			is_facing_left = false
			sprite.play("shoot_right")
			attempt_shoot()
	else:
		# No target detected, play idle animation
		sprite.play("idle")

func attempt_shoot():
	# Check if enough time has passed to fire
	if time_since_last_shot >= fire_interval:
		time_since_last_shot = 0.0  # Reset the timer
		shoot()

func shoot():
	if projectile:
		var new_projectile = projectile.instantiate()
		if new_projectile:
			# Set the projectile's initial position and direction
			new_projectile.global_position = global_position
			new_projectile.position += Vector2(-20 if is_facing_left else 20, 0)  # Offset slightly to match direction
			if new_projectile.has_method("set_direction"):
				new_projectile.set_direction(Vector2.LEFT if is_facing_left else Vector2.RIGHT)
			get_parent().add_child(new_projectile)
			print("Projectile created.")
		else:
			print("Error: Could not instantiate projectile.")
