extends CanvasLayer

var health_display = null
var greyscale_rect : TextureRect
var blackout_rect : TextureRect
var animation_player : AnimationPlayer
var is_grey : bool = false
func _ready():
	health_display = $Control/MarginContainer/HBoxContainer/health_display
	animation_player = $AnimationPlayer
	if health_display != null:
		health_display.play("high")

func _play_animation(animation_name : StringName) -> void:
	if health_display.animation != animation_name:
		health_display.play(animation_name)
