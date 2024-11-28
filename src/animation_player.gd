extends AnimationPlayer

var anim_name : StringName


func transition_greyscale(grey : bool):
	if grey:
		play("greyscale")
	else:
		play("ungreyscale")
func pulse_black():
	play("pulse_black")
func pulse_black_ghost():
	play("death")
func pulse_black_ungrey():
	play_backwards("death")
func fade_to_black():
	play("fade_to_black")
func fade_to_black_ghost():
	play("fade_to_black_ghost")
func unfade_from_black():
	play("unfade_from_black")
func unfade_from_black_ghost():
	play("unfade_from_black_ghost")
