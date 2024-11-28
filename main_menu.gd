extends Node2D

var startScene = "res://Startscene.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preload("res://Startscene.tscn")



func _on_button_pressed() -> void:
	load(startScene).instantiate()
