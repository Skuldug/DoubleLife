extends AnimationPlayer

func transition_greyscale(grey : bool):
	if grey:
		play("greyscale")
	else:
		play("ungreyscale")
func fade_black():
	play("blackout")
func grey_blackout():
	play("death")
func ungrey_blackout():
	play_backwards("death")
func fade_black_ghost():
	play("blackout_ghost")
