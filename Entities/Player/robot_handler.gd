extends Node


var robots: Array = []
var current_bot: int = 0
var robot_last_index: int = 0
var _has_robots: bool = true


func _ready() -> void:
	robots = get_children()
	robot_last_index = _get_last_index()
	robots[0].is_active = true


func _unhandled_input(event: InputEvent) -> void:
	if not _has_robots: return
	if Input.is_action_just_pressed("activate_weapon") and robots[current_bot].is_usable:
		robots[current_bot].is_active = false
		robots[current_bot].ap.play("detonate")
		robots[current_bot].is_usable = false
		robots.remove_at(current_bot)
		robot_last_index = _get_last_index()
		if robot_last_index < 0:
			_has_robots = false
			return
		if current_bot > robot_last_index:
			current_bot = 0
		robots[current_bot].is_active = true
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			robots[current_bot].is_active = false
			if current_bot >= robot_last_index:
				current_bot = 0
			else:
				current_bot += 1
			robots[current_bot].is_active = true
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			robots[current_bot].is_active = false
			if current_bot == 0:
				current_bot = robot_last_index
			else:
				current_bot -= 1
			robots[current_bot].is_active = true


func _get_last_index() -> int:
	return len(robots) - 1
