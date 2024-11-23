extends Area2D

@export var speed: float = 500.0  # Speed of the fireball
var direction: Vector2 = Vector2.RIGHT  # Default direction
@export var lifetime: float = 3.0  # Fireball disappears after this time

func _ready():
	# Schedule the fireball to be removed after its lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	# Move the fireball in its direction
	position += direction * speed * delta

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
