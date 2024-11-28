extends CanvasLayer

signal load_cutscene()
@onready var text_label : Label = $AnimatedSprite2D/Control/HBoxContainer/VBoxContainer/Label 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var anim_sprite = $AnimatedSprite2D
	anim_sprite.play("default")


func _on_label_gui_input(event: InputEvent) -> void:
	if event.is_action("left_click"):
		load_cutscene.emit()



func _on_label_mouse_entered() -> void:
	text_label.label_settings.font_color = Color("#f1c454")


func _on_label_mouse_exited() -> void:
	text_label.label_settings.font_color = Color("#ffffff")
