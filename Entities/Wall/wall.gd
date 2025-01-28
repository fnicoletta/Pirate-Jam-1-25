class_name Wall
extends RigidBody2D


@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func destroy_wall() -> void:
	sprite.scale *= .3
	collision_shape.scale *= .3
	collision_shape.set_deferred("disabled", true)
