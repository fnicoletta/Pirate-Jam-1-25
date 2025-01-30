class_name Player
extends CharacterBody2D


signal exploded

enum PotionType { GREEN, BLUE, RED, PURPLE }

@export var speed: float = 100.0
@export var jump_impulse: float = -200.0
@export var camera: Camera2D

const PLATFORM = preload("res://Entities/Platform/platform.tscn")

var is_active: bool = false:
	set(value):
		arrow.visible = value
		is_active = value
var is_usable: bool = true
var _ability = null
var _is_floating: bool = false
var _platform_count: int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var ap: AnimationPlayer = $AnimationPlayer
@onready var blast_radius: Area2D = $Area2D
@onready var gpu_particles: GPUParticles2D = $GPUParticles2D
@onready var arrow: Sprite2D = $Arrow
@onready var jump: AudioStreamPlayer = $Jump
@onready var goo: Sprite2D = $Goo
@onready var blast_radius_collision: CollisionShape2D = $Area2D/BlastRadius
@onready var platform_spawner: Marker2D = $PlatformSpawner
@onready var ability_timer: Timer = $AbilityTimer


func _ready() -> void:
	blast_radius.monitoring = false
	goo.visible = false


func _physics_process(delta: float) -> void:
	if not is_on_floor() and not _is_floating:
		velocity += get_gravity() * delta
	
	var direction: float = _handle_input(delta)
	_handle_movement(direction)
	
	move_and_slide()


func _handle_input(delta: float) -> float:
	if not is_active or not is_usable: return 0
	if is_on_floor(): _is_floating = false
	if is_on_floor() and _ability == PotionType.BLUE and Input.is_action_pressed("jump"):
		jump.play()
		velocity.y = -200
		_is_floating = true
	elif _is_floating and _ability == PotionType.BLUE:
		velocity.y += 200 * delta
		velocity.y = min(velocity.y, 200)
	elif is_on_floor() and Input.is_action_just_pressed("jump"):
		jump.play()
		velocity.y = jump_impulse
	elif not is_on_floor() and _ability == PotionType.PURPLE and Input.is_action_just_pressed("jump"):
		_platform_count += 1
		var instance = PLATFORM.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = platform_spawner.global_position
		if _platform_count >= 3:
			_revert_potions()
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


func handle_goo(color: PotionType) -> void:
	_revert_potions()
	_ability = color
	
	if not _ability: return
	
	if not goo.visible:
		goo.visible = true
	
	ability_timer.start()
	
	match color:
		PotionType.GREEN:
			_apply_green()
		PotionType.RED:
			_apply_red()
		PotionType.PURPLE:
			_apply_purple()
		PotionType.BLUE:
			_apply_blue()


func _apply_green() -> void:
	goo.frame = 0


func _apply_red() -> void:
	goo.frame = 1
	blast_radius_collision.scale = Vector2(2, 2)


func _apply_purple() -> void:
	goo.frame = 2
	_platform_count = 0


func _apply_blue() -> void:
	goo.frame = 3


func _revert_potions() -> void:
	_ability = null
	goo.visible = false
	blast_radius_collision.scale = Vector2(1, 1)
	_platform_count = 0


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


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "detonate":
		goo.visible = false


func _on_ability_timer_timeout() -> void:
	_revert_potions()
