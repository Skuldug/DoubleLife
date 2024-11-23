extends StaticBody2D

@export var immobilization_duration = 2.0  # Duration the player is immobilized
var player : CharacterBody2D = null  # Reference to the player

var immobilized_timer : Timer = null

func _ready():
	immobilized_timer = Timer.new()
	
	add_child(immobilized_timer)
	
	immobilized_timer.connect("timeout", Callable(self, "_on_immobilized_timeout"))
	
	immobilized_timer.autostart = false

func _on_body_entered(body: Node):
	if body is CharacterBody2D:  # Check if the player stepped on the trap
		print("Body entered: ", body.name)  # Check if it's detecting the right body

		player = body  # Store reference to the player
		immobilize_player()  # Start the immobilization

func immobilize_player():
	if player:
		player.velocity = Vector2.ZERO  # Stop player movement (assuming 'velocity' controls movement)
		immobilized_timer.start(immobilization_duration)  # Start the timer

# Called when the immobilization timer expires
func _on_immobilized_timeout():
	if player:
		player.velocity = Vector2.ZERO  # Ensure player remains stopped
		player = null  # Clear the player reference
