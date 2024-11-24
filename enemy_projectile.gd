extends Area2D

@export var speed: float = 300.0
@export var lifetime: float = 3.0
@export var damage : int = 20
@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D
var direction: Vector2 = Vector2.ZERO  # Bullet directionnew_animation
var playing_anim : bool = false

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
	if !playing_anim:
		if direction.x > 0:
			anim_sprite.play("right")
		elif direction.x < 0:
			anim_sprite.play("left")
	
	# If the bullet is outside of the viewport, it is destroyed
	if not get_viewport().get_visible_rect().has_point(global_position):
		queue_free()

func _on_body_entered(body: Node) -> void:
	# If the bullet collides with a target, it is destroyed along with the target
	if body.is_in_group("Player"): 
		queue_free()
		body._on_player_hit(damage)
