extends StaticBody2D

signal player_reached_end

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player reached end")
		player_reached_end.emit()
