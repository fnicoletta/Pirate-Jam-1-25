extends Node2D

const LEVEL_1 = preload("res://Levels/Level_1/level_1.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(LEVEL_1)
