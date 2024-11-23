extends Node

var health_in_frames : int = 600

var health_display = null

const DEFAULT_FRAMES = 60

func check_health(delta : float) -> void:
	health_in_frames -= 1 * DEFAULT_FRAMES * delta
	print(health_in_frames)
	if health_in_frames == 400:
		health_display.play("medium")
	if health_in_frames == 200:
		health_display.play("low")
func player_hit(damage : int) -> void:
	health_in_frames -= damage 
func set_health_display(param_health_display : AnimatedSprite2D) -> void:
	health_display = param_health_display
