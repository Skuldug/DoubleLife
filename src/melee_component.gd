extends Area2D

var damage : int
var timer : Timer = Timer.new()
var target : CharacterBody2D

func _ready() -> void:
	self.add_child(timer)
	timer.timeout.connect(self._on_timer_timeout)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		timer.start(0.5)
		target = body
func _on_timer_timeout():
	if target:
		target.on_player_hit(damage)



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = null
		timer.stop() # Replace with function body.
