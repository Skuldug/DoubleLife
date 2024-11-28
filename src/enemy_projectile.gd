extends Area2D

@export var speed: float = 300.0                # Speed of the projectile
@export var lifetime: float = 3.0              # Lifetime before the projectile disappears
@export var damage: int = 400                  # Damage dealt by the projectile

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction: Vector2 = Vector2.ZERO          # Direction of movement
var playing_anim: bool = false                 # Tracks if animation has started
var timer: Timer                               # Timer for lifetime tracking

func _ready() -> void:
	# Initialize and start the timer
	timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "queue_free"))
	add_child(timer)
	timer.start()
	print("Projectile created.")

	# Connect signal for collision detection
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	# Move the projectile based on direction and speed
	global_position += direction * speed * delta
	
	# Play the appropriate animation based on the direction
	if not playing_anim:
		playing_anim = true
		if direction.x > 0:
			anim_sprite.play("right")
		elif direction.x < 0:
			anim_sprite.play("left")

func set_direction(direction):
	self.direction = direction

func _on_body_entered(body: Node) -> void:
	
	# Handle collision with a player
	if body.is_in_group("Player"):
		body.on_player_hit(damage)  # Call damage method on the player
		queue_free()  # Destroy the projectile
