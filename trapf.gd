extends Area2D  # Assuming this is the trap

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D

func _ready() -> void:
	# Start the default animation (e.g., idle animation)
	animated_sprite.play("idle")  # Replace "idle" with your animation name if different

	# Connect the signal for detecting when something enters the trap
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	print("Body entered the trap: ", body.name)
	# Trigger a different animation, e.g., "trap_activated"
	if animated_sprite.has_animation("trap_activated"):
		animated_sprite.play("trap_activated")
