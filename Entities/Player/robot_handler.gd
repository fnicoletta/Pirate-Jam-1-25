extends Node


var robots: Array = []
var current_bot: int = 0


func _ready() -> void:
	robots = get_children()
	if robots.size() > 0:
		robots[0].is_active = true
	for robot in robots:
		robot.exploded.connect(remove_current_bot)


func _unhandled_input(event: InputEvent) -> void:
	if robots.size() == 0: return  # Exit if no robots are available

	# Handle weapon activation
	if Input.is_action_just_pressed("activate_weapon") and robots[current_bot].is_usable:
		robots[current_bot].start_explode()

	# Handle mouse wheel input for switching robots
	if event is InputEventMouseButton:
		if not event.pressed:  # Skip release events
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			switch_robot(1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			switch_robot(-1)


func switch_robot(direction: int) -> void:
	if robots.size() == 0: return  # Exit if no robots are left

	# Deactivate current bot
	robots[current_bot].is_active = false

	# Update current bot index
	current_bot = (current_bot + direction) % robots.size()
	if current_bot < 0:  # Handle negative wrap-around
		current_bot += robots.size()

	# Activate the new bot
	robots[current_bot].is_active = true


func remove_current_bot() -> void:
	if robots.size() == 0: return  # Avoid errors if the array is empty

	# Deactivate and remove the current bot
	robots[current_bot].is_active = false
	robots.remove_at(current_bot)

	# Adjust current_bot index
	if robots.size() > 0:
		current_bot = current_bot % robots.size()  # Wrap if needed
		robots[current_bot].is_active = true
	else:
		current_bot = 0  # Reset index if no robots are left
