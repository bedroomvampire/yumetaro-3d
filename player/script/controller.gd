extends KinematicBody

export var speed = 14
export var jump_strength = 24
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") * 6)

var _velo = Vector3.ZERO
var _snap_velo = Vector3.DOWN

onready var cam_arm: SpringArm = $SpringArm
onready var player_model: Spatial = $Spatial

func _physics_process(delta):
	var mov_dir = Vector3.ZERO
	mov_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	mov_dir.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	mov_dir = mov_dir.rotated(Vector3.UP, cam_arm.rotation.y).normalized()
	
	$AnimationTree.set("parameters/conditions/idle", mov_dir == Vector3.ZERO && is_on_floor())
	$AnimationTree.set("parameters/conditions/move", mov_dir != Vector3.ZERO && is_on_floor())
	$AnimationTree.set("parameters/conditions/jump", !is_on_floor())
	
	_velo.x = mov_dir.x * speed
	_velo.z = mov_dir.z * speed
	_velo.y -= gravity * delta
	
	var landed = is_on_floor() and _snap_velo == Vector3.ZERO
	var jump_true = is_on_floor() and Input.is_action_just_pressed("jump")
	if jump_true:
		_velo.y = jump_strength
		_snap_velo = Vector3.ZERO
	elif landed:
		_snap_velo = Vector3.DOWN
	_velo = move_and_slide_with_snap(_velo, _snap_velo, Vector3.UP, true)
	
	if _velo.length() > 0.2:
		var look_dir = Vector2(_velo.z, _velo.x)
		if mov_dir != Vector3.ZERO:
			player_model.rotation.y = lerp_angle(player_model.rotation.y, atan2(_velo.x, _velo.z),  16 * delta)
		

func _process(delta: float) -> void:
	cam_arm.translation = translation
