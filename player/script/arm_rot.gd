extends SpringArm

export var mouse_sens = 0.1

func _ready() -> void:
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sens
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 15)
		
		rotation_degrees.y -= event.relative.x * mouse_sens
		rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
