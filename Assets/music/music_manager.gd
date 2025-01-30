extends Node


@onready var player: AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	player.play()

func play_music(stream: AudioStream):
	if player.stream != stream:
		player.stream = stream
		player.play()
