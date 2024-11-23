extends Node2D

var healthbar = null
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthbar = preload("res://healthbar.tscn")
	var health_display : AnimatedSprite2D = get_node("Healthbar/Control/MarginContainer/HBoxContainer/health_display")
	health_display.play("high")
	var player_health_component : Node = get_node("Player/PlayerHealthComponent")
	var player : Node = get_node("Player")
	player.set_component(player_health_component)
	player_health_component.set_health_display(health_display)
	
