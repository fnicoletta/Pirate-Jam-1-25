class_name Player
extends CharacterBody2D


signal exploded

@export var speed: float = 100.0
@export var jump_impulse: float = -200.0
@export var camera: Camera2D

var is_active: bool = false:
	set(value):
		arrow.visible = value
		is_active = value
var is_usable: bool = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var blast_radius: Area2D = $Area2D
@onready var gpu_particles: GPUParticles2D = $GPUParticles2D
@onready var arrow: Sprite2D = $Arrow
@onready var jump: AudioStreamPlayer = $Jump


func _ready() -> void:
	blast_radius.monitoring = false


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction: float = _handle_input()
	_handle_movement(direction)
	
	move_and_slide()


func _handle_input() -> float:
	if not is_active or not is_usable: return 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		jump.play()
		velocity.y = jump_impulse
	var direction: float = Input.get_axis("move_left", "move_right")
	return direction


func _handle_movement(direction: float) -> void:
	if not is_active or not is_usable:
		velocity.x = lerpf(velocity.x, 0, .05)
		return
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


func start_explode() -> void:
	if not is_usable: return
	ap.play("detonate")
	exploded.emit()


func shake() -> void:
	is_usable = false
	camera.apply_shake()


func knockback(origin: Vector2, force: float = 500.0) -> void:
	start_explode()
	# Calculate knockback direction and apply force
	var direction = (global_position - origin).normalized()
	velocity += direction * force


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("break_potion"):
		area.break_potion()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not body.is_usable:
		# if the body just exploded then we don't want to interact with it
		body.set_collision_layer_value(2, false)
		body.set_collision_mask_value(2, false)
	if body.has_method("destroy_wall"):
		body.destroy_wall()
	if body.has_method("knockback"):
		body.knockback(global_position)
