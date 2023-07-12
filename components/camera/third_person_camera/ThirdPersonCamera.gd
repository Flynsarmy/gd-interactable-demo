extends Node3D

const EIGTH_TURN: float = PI/4
const SENSITIVITY: float = 0.005

@export var spring_arm: SpringArm3D
@export var invert_x: bool = false
@export var invert_y: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	# Mouse camera movement
	if event is InputEventMouseMotion:
		rotate_y((1 if invert_x else -1) * event.relative.x * SENSITIVITY)
		spring_arm.rotate_x((1 if invert_y else -1) * event.relative.y * SENSITIVITY)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -EIGTH_TURN, EIGTH_TURN)
	elif event is InputEventKey and event.is_pressed() and (event as InputEventKey).keycode == KEY_ESCAPE:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
