extends Node2D

@export var detection_distance: float = 200.0  # Detection range
@export var fire_interval: float = 1.5         # Time between shots
@export var bullet_scene: PackedScene          # The scene for the bullet

@onready var sprite = $AnimatedSprite2D        # Reference to the AnimatedSprite2D
@onready var raycast = $RayCast2D              # Reference to the RayCast2D

var target_detected = false
var is_facing_left = true  # Initial facing direction
var last_fire_time = 0.0   # Timer to control shooting

func _ready():
	sprite.play("stand")  # Start with the stand animation
	raycast.enabled = true  # Ensure the RayCast2D is enabled

func _process(delta):
	check_for_target(delta)

func check_for_target(delta):
	# Update RayCast based on current direction (facing left or right)
	if is_facing_left:
		raycast.target_position = Vector2(-detection_distance, 0)  # Cast left
	else:
		raycast.target_position = Vector2(detection_distance, 0)  # Cast right

	# Perform the raycast check
	raycast.force_raycast_update()  # Manually update the RayCast for detection

	if raycast.is_colliding():
		var target = raycast.get_collider()
		if target:
			# Switch direction if needed
			if is_facing_left and raycast.target_position.x > 0:
				turn_right()
			elif not is_facing_left and raycast.target_position.x < 0:
				turn_left()
			
			
			shoot()
	else:
		# If no target, stay in the stand position
		sprite.play("stand")

func turn_left():
	is_facing_left = true
	sprite.play("idle_left")  # Set idle animation when facing left

func turn_right():
	is_facing_left = false
	sprite.play("idle_right")  # Set idle animation when facing right

func shoot():
	var current_time = get_tree().get_seconds_since_startup()  # Get the time since the game started in seconds
	if current_time - last_fire_time >= fire_interval:
		last_fire_time = current_time

		
		sprite.play("shoot")
		
		
		if bullet_scene:
			var bullet = bullet_scene.instantiate()
			bullet.global_position = global_position
			bullet.position += Vector2(-20 if is_facing_left else 20, 0)  # Offset to match direction
			bullet.direction = Vector2.LEFT if is_facing_left else Vector2.RIGHT
			get_parent().add_child(bullet)
