extends Camera2D


@export var random_strength: float = 30.0
@export var shake_fade: float = 5.0

var _rng = RandomNumberGenerator.new()
var _shake_strength: float = 0.0
var is_exploding: bool = false


func _process(delta: float) -> void:
	if is_exploding:
		apply_shake()
	if _shake_strength > 0:
		_shake_strength = lerpf(_shake_strength, 0, shake_fade * delta)
		offset = random_offset()


func apply_shake() -> void:
	_shake_strength = random_strength


func random_offset() -> Vector2:
	return Vector2(_rng.randf_range(-_shake_strength, _shake_strength), _rng.randf_range(-_shake_strength, _shake_strength))
