extends CanvasLayer

var health_display = null
var greyscale_rect : TextureRect
var blackout_rect : TextureRect
var animation_player : AnimationPlayer
var is_grey : bool = false
func _ready():
	greyscale_rect = %Greyscale
	greyscale_rect.z_index = 100
	blackout_rect = %Blackout
	blackout_rect.z_index = 100
	health_display = $Control/MarginContainer/HBoxContainer/health_display
	animation_player = $AnimationPlayer
	if health_display != null:
		health_display.play("high")

func _play_animation(animation_name : StringName) -> void:
	if health_display.animation != animation_name:
		health_display.play(animation_name)


# Toggles the visibility of this CanvasLayer
func set_greyscale(grey : bool) -> void:
	if is_grey != grey:
		print(grey)
		is_grey = grey
		animation_player.transition_greyscale(grey)
		

func fade_black():
	animation_player.fade_black()
	print("fading black")
func grey_blackout():
	is_grey = true
	animation_player.grey_blackout()
	print("grey blackout")
func ungrey_blackout():
	is_grey = false
	animation_player.ungrey_blackout()
	print("grey blackout")
func fade_black_ghost():
	is_grey = false
	animation_player.fade_black_ghost()
