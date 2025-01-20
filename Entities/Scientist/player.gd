extends CharacterBody2D


@export var speed: float = 150.0


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
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
