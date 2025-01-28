class_name Collectable
extends Area2D


signal collected
var _is_collected: bool = false
@onready var audio: AudioStreamPlayer = $Collected


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not _is_collected:
		_is_collected = true
		visible = false
		audio.play()
		collected.emit()

func _on_collected_finished() -> void:
	queue_free()
