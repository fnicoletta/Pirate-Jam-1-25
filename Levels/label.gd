extends Label


@export var collectables: Node2D

var coins: int = 0

func _ready() -> void:
	for collectable in collectables.get_children():
		collectable.collected.connect(_increase_coins)


func _increase_coins() -> void:
	coins += 1
	text = str(coins)
