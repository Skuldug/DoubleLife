extends Node

signal play_animation(animation : StringName)
signal on_player_death()

const MAX_HEALTH : int = 400
const med_threshold : int = MAX_HEALTH / 3 * 2
const low_threshold : int = MAX_HEALTH / 3
var health_in_frames : int = MAX_HEALTH
var med_signal_sent : bool = false
var low_signal_sent : bool = false

const DEFAULT_FRAMES = 60

func _process(delta : float) -> void:
	health_in_frames -= 1 * DEFAULT_FRAMES * delta
	if health_in_frames < med_threshold and health_in_frames > low_threshold and !med_signal_sent:
		play_animation.emit("medium")
		med_signal_sent = true
		return
	if health_in_frames < low_threshold and !low_signal_sent:
		play_animation.emit("low")
		low_signal_sent = true
	if health_in_frames <= 0:
		on_player_death.emit()
		_health_reset()
		
func _take_damage(damage : int) -> void:
	health_in_frames -= damage
func _health_reset():
	play_animation.emit("high")
	med_signal_sent = false
	low_signal_sent = false
	health_in_frames = MAX_HEALTH
