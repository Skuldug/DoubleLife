extends AnimatedSprite2D

signal death_finished()
signal ghost_death_finished()
signal ressurection_finished()
var anim_name : StringName
	

func _on_animation_changed() -> void:
	self.anim_name = animation

func _on_animation_finished() -> void:
	match anim_name:
		&"death":
			print("emitting death")
			death_finished.emit()
		&"ghost_death":
			ghost_death_finished.emit()
		&"ressurection":
			ressurection_finished.emit()
