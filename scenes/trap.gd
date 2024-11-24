extends StaticBody2D

@export var immobilization_duration = 2.0  # Duration the player is immobilized
@export var rearm_duration = 10.0
var anim_sprite : AnimatedSprite2D
var active : bool = true
var body : CharacterBody2D = null  # Reference to the player
var immobilized_timer : Timer = null
var rearm_timer : Timer = null
var is_timer_running : bool = false

func _ready():
	immobilized_timer = Timer.new()
	
	add_child(immobilized_timer)
	
	immobilized_timer.connect("timeout", Callable(self, "_on_immobilized_timeout"))
	
	immobilized_timer.autostart = false
	
	rearm_timer = Timer.new()
	
	add_child(immobilized_timer)
	
	rearm_timer.timeout.connect(_on_rearm_timeout)
	
	rearm_timer.autostart = false
	
	anim_sprite = $AnimatedSprite2D
	anim_sprite.play("idle")

func _on_body_entered(body: Node):
	if active:
		active = false
		self.body = body  # Store reference to the player
		print(body)
		body.set_physics_process(false)
		anim_sprite.play("explode")
		immobilized_timer.start(immobilization_duration)

# Called when the immobilization timer expires
func _on_immobilized_timeout():
	body.set_physics_process(true)
	rearm_timer.start(rearm_duration)

func _on_rearm_timeout():
	active = true
	anim_sprite.play("rearm")
