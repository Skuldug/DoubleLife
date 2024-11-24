extends StaticBody2D

signal on_ghost_entered()
@onready var anim_sprite = $AnimatedSprite2D
var enter_counter : int = 0
var timer : Timer
var act_as_new_spawn : bool = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !act_as_new_spawn:
		if !enter_counter:
			enter_counter += 1
			return
		act_as_new_spawn = true
		on_ghost_entered.emit()
		rise_gravestone()
		visible = false

func rise_gravestone():
	timer = Timer.new()
	self.add_child(timer)
	timer.timeout.connect(self._on_timer_timeout)
	timer.start(1.5)
func _on_timer_timeout():
	timer.stop()
	visible = true
	anim_sprite.play("grave_rise")
		
		
