class_name Player
extends CharacterBody2D


@export var speed: float = 100.0

var is_active: bool = false
var is_usable: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var ap: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction: float = _handle_input()
	_handle_movement(direction)
	
	move_and_slide()


func _handle_input() -> float:
	var direction: float = Input.get_axis("move_left", "move_right")
		
	return direction


func _handle_movement(direction: float) -> void:
	if not is_active: return
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	if direction:
		ap.play("walk")
		velocity.x = direction * speed
	else:
		ap.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
