extends CharacterBody3D


const ROTATION_SPEED: float = 0.15
const ACCELERATION: float = 0.5
const SPEED = 5.0
const JUMP_VELOCITY = 3.8

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var armature: Node3D = $Visuals/Armature
@onready var camera_pivot: Node3D = $CameraPivot

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_angle: float = input_dir.angle_to(Vector2.UP)
	var input_length: float = input_dir.length()

	# Face character in direction of input
	if input_length > 0:
		armature.rotation.y = lerp_angle(
			armature.rotation.y,
			# Away from camera
			camera_pivot.rotation.y +
				# Offset by current animation's hip bone
				# i.e our idle animation has them facing 21 degrees right
				#animation_tree.get_root_motion_rotation_accumulator().y +
				input_angle,
				#(input_angle if input_angle > (-PI / 2) else 0),
			ROTATION_SPEED
		)

	animation_tree['parameters/conditions/running'] = input_length > 0.1
	animation_tree['parameters/conditions/idling'] = input_length < 0.1

	#var direction = (armature.basis * Vector3.FORWARD * input_length).normalized()
	var direction: Vector3 = (Vector3.FORWARD * input_length).rotated(Vector3.UP, armature.rotation.y).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
