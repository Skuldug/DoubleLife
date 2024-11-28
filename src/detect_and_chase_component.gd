extends Area2D

var target = null

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = body
		get_parent().found_player(body)

func  _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_parent().lost_player()
