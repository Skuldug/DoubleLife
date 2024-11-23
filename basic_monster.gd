extends CharacterBody2D

var run_speed = 25
var chase = false
var health = 10
var target = null
var damage = 20
@onready var timer = $Timer

func _physics_process(delta) -> void:
	velocity = Vector2.ZERO
	if target:
		velocity = position.direction_to(target.position) * run_speed
	move_and_collide(velocity)

func _on_area_2d_body_entered(body: Node2D) -> void:
	target = body
	if target.is_in_group("Player"):
		body = target


func _on_swing_body_entered(body: Node2D) -> void:
	target = body
	target.health -= 10
func _on_timer_timeout() -> void:
	target.health -= 10
	print (target.health)

func _on_swing_body_exited(body: Node2D) -> void:
	pass
