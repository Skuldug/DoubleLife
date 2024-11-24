extends Node2D

@export var detection_distance: float = 200.0  # Detection range
@export var fire_interval: float = 1.5         # Time between shots
@export var projectile: PackedScene            # The scene for the bullet

@onready var sprite = $AnimatedSprite2D        # Reference to the AnimatedSprite2D
@onready var left_cast = %left_cast             # Left RayCast2D node
@onready var right_cast = %right_cast           # Right RayCast2D node

var target_detected = false
var last_fire_frame = 0  # Frame counter for controlling shooting
var is_facing_left = true  # Track the enemy's direction

func _ready():
	# Enable the RayCasts
	left_cast.enabled = true
	right_cast.enabled = true
	sprite.play("idle")  # Start with the idle animation

func _process(_delta):
	check_for_target()

func check_for_target():
	# Ensure RayCasts are properly updated
	left_cast.target_position = Vector2(-detection_distance, 0)
	right_cast.target_position = Vector2(detection_distance, 0)
	left_cast.force_raycast_update()
	right_cast.force_raycast_update()

	var target = null

	# Check left cast
	if left_cast.is_colliding():
		var collider = left_cast.get_collider()
		if collider and collider.is_in_group("Player"):
			is_facing_left = true
			target = collider

	# Check right cast
	if right_cast.is_colliding() and target == null:  # Check right only if no left target
		var collider = right_cast.get_collider()
		if collider and collider.is_in_group("Player"):
			is_facing_left = false
			target = collider

	# Handle animations and shooting logic
	if target:
		if is_facing_left:
			sprite.play("shoot_left")
		else:
			sprite.play("shoot_right")
		shoot()
	else:
		sprite.play("idle")  # No target, return to idle

func shoot():
	var current_frame = Engine.get_physics_frames()  # Get the current frame
	var frames_between_shots = int(fire_interval / Engine.get_physics_frames())  # Convert interval to frames

	if current_frame - last_fire_frame >= frames_between_shots:
		last_fire_frame = current_frame
			
		if projectile:
			var new_projectile = projectile.instantiate()
			new_projectile.global_position = global_position
			new_projectile.position += Vector2(-20 if is_facing_left else 20, 0)  # Offset to match direction
			new_projectile.direction = Vector2.LEFT if is_facing_left else Vector2.RIGHT
			get_parent().add_child(new_projectile)
