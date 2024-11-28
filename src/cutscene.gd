extends Node2D

signal on_any_key_in_cutscene()

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if is_in_group("start_scene"):
			on_any_key_in_cutscene.emit()
		else:
			on_any_key_in_cutscene.emit()
