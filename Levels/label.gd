extends Label


@export var collectables: Node2D

var chips: int = 0
var total_chips: Array

func _ready() -> void:
	total_chips = collectables.get_children()
	for collectable in total_chips:
		collectable.collected.connect(_increase_coins)


func _increase_coins() -> void:
	chips += 1
	text = str(chips)
	if chips == len(total_chips):
		text = "You Win!"
