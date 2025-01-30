@tool
extends Area2D


enum PotionType { GREEN, BLUE, RED, PURPLE }

@export var potion_type: PotionType = PotionType.GREEN:
	set(v):
		potion_type = v
		_handle_color(potion_type)
@export var goop_height: int = 0:
	set(v):
		goop_height = v
		_handle_goop_height(goop_height)
@export var is_goop_visible: bool = false:
	set(v):
		is_goop_visible = v
		_handle_goop_visible(is_goop_visible)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite
@onready var goop: Area2D = $Goop
@onready var goop_sprite: Sprite2D = $Goop/GoopSprite
@onready var potion_collision: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_handle_color(potion_type)
	_handle_goop_height(goop_height)
	_handle_goop_visible(is_goop_visible)


func break_potion() -> void:
	print("breaking potion")
	is_goop_visible = true
	sprite.visible = false
	potion_collision.set_deferred("disabled", true)


func _handle_goop_visible(is_visible) -> void:
	if not goop or is_visible == goop.visible: return
	goop.visible = is_visible


func _handle_goop_height(number_of_blocks: int) -> void:
	if not goop: return
	var actual = number_of_blocks * -16 + 10 # the plus ten is to align it with the potion
	goop.position.y = actual


func _handle_color(color: PotionType) -> void:
	if not sprite: return
	match color:
		PotionType.GREEN:
			sprite.play("green")
			goop_sprite.frame = 0
		PotionType.RED:
			sprite.play("red")
			goop_sprite.frame = 1
		PotionType.PURPLE:
			sprite.play("purple")
			goop_sprite.frame = 2
		PotionType.BLUE:
			sprite.play("blue")
			goop_sprite.frame = 3
