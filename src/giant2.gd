extends CharacterBody2D

const SPEED = 100.0   # Slower speed
const STEP_SIZE = 50.0  # Increased the distance moved per step (50cm for example)
const NUM_STEPS = 50    # Increased the number of steps to move left or right (50 steps)
var steps_left = NUM_STEPS  # Number of steps left to move in the current direction
var moving_right = true    # Flag to track whether we are moving right or left

func _ready():
	# Initialize the movement direction
	set_random_direction()

func _physics_process(delta: float) -> void:
	# If we are at the end of the steps, change direction
	if steps_left <= 0:
		moving_right = !moving_right  # Reverse the direction
		steps_left = NUM_STEPS       # Reset steps for the new direction
		set_random_direction()  # Set a random small random movement direction

	# Move based on the current direction
	if moving_right:
		velocity.x = STEP_SIZE * SPEED / 4
	else:
		velocity.x = -STEP_SIZE * SPEED / 4
	
	# Apply movement
	move_and_slide()

	# Decrease steps left as we move
	steps_left -= 1

# Function to generate a small random direction within the range to add some variance
func set_random_direction():
	# Optionally, introduce some random noise (small variation) to make the movement feel less rigid
	velocity.x += randf_range(-0.5, 0.5)  # Small random noise for a slightly less predictable movement
