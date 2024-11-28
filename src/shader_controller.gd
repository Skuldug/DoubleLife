extends CanvasLayer

signal shader_effect_finished(animation : StringName)

@onready var animation_player : AnimationPlayer = $Control/AnimationPlayer
func transition_greyscale(grey : bool):
	animation_player.transition_greyscale(grey)
	
func pulse_black():
	animation_player.pulse_black()

func pulse_black_ghost():
	animation_player.pulse_black_ghost()
	
func fade_to_black():
	animation_player.fade_to_black()
func unfade_from_black():
	animation_player.unfade_from_black()
func fade_to_black_ghost():
	animation_player.fade_to_black_ghost()
func unfade_from_black_ghost():
	animation_player.unfade_from_black_ghost()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	shader_effect_finished.emit(anim_name)
