extends Area2D

@export var speed: float = 300.0
@export var lifetime: float = 3.0

var direction: Vector2 = Vector2.ZERO  # Bullet direction

var timer: Timer

func _ready() -> void:
	# Create and start the timer to handle the bullet lifetime
	timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	add_child(timer)
	timer.start()

	# Connect the signal for when the bullet collides with something
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	# Move the bullet based on direction and speed
	global_position += direction * speed * delta
	
	# If the bullet is outside of the viewport, it is destroyed
	if not get_viewport().get_visible_rect().has_point(global_position):
		queue_free()

func _on_body_entered(body: Node) -> void:
	# If the bullet collides with a target, it is destroyed along with the target
	if body.is_in_group("target"): 
		queue_free()
		body.queue_free()
