extends Node2D


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
