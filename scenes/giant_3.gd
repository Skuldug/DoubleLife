extends CharacterBody2D

const SPEED = 25.0   # Slower speed
const STEP_SIZE = 50.0  # Increased the distance moved per step (50cm for example)
const NUM_STEPS = 50    # Increased the number of steps to move left or right (50 steps)
var steps_left = NUM_STEPS  # Number of steps left to move in the current direction
var moving_right = true    # Flag to track whether we are moving right or left

@export var fireball_scene: PackedScene  # Reference to the fireball scene (Node2D)
@export var fire_interval: float = 2.0   # Fireball throw interval in seconds

func _ready():
	# Initialize the movement direction
	set_random_direction()
	
	# Start a timer to throw fireballs automatically
	var fire_timer = Timer.new()
	fire_timer.wait_time = fire_interval
	fire_timer.autostart = true
	fire_timer.one_shot = false
	add_child(fire_timer)
	fire_timer.connect("timeout", Callable(self, "_on_fire_timer_timeout"))


func _physics_process(delta: float) -> void:
	# If we are at the end of the steps, change direction
	if steps_left <= 0:
		moving_right = !moving_right  # Reverse the direction
		steps_left = NUM_STEPS       # Reset steps for the new direction
		set_random_direction()  # Set a random small random movement direction

	# Move based on the current direction
	velocity.x = (STEP_SIZE * SPEED / 4) * (1 if moving_right else -1)
	move_and_slide()

	# Decrease steps left as we move
	steps_left -= 1

# Function to generate a small random direction within the range to add some variance
func set_random_direction():
	velocity.x += randf_range(-0.5, 0.5)  # Small random noise for a slightly less predictable movement

# Function triggered by the timer to throw fireballs
func _on_fire_timer_timeout():
	throw_fireball()

# Function to instantiate and throw a fireball
func throw_fireball():
	if fireball_scene == null:
		print("Fireball scene not assigned!")
		return

	var fireball = fireball_scene.instantiate()  # Create a fireball instance
	get_parent().add_child(fireball)  # Add the fireball to the scene

	# Position the fireball at the giant's position
	fireball.global_position = global_position

	# Adjust fireball's position slightly forward (optional)
	fireball.position += Vector2(20 if moving_right else -20, 0)

	# Set the direction of the fireball
	if fireball.has_method("set_direction"):
		fireball.set_direction(Vector2.RIGHT if moving_right else Vector2.LEFT)
