extends CharacterBody3D

@onready var animation_player = $visuals/player_idle/AnimationPlayer
@onready var visuals = $visuals
@onready var camera_pivot = $CameraPivot

var SPEED = 1.0
var walking_speed = 1.0
var running_speed = 2.0
const JUMP_VELOCITY = 4.5

var sens_horizontal = 0.2
var sens_vertical = 0.2

var is_running = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		#visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		camera_pivot.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))

func _physics_process(delta):
	
	if Input.is_action_pressed("run"):
		SPEED = running_speed
		is_running = true
	else:
		SPEED = walking_speed
		is_running = false
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_running:
			if animation_player.current_animation != "run/run":
				animation_player.play("run/run")
		else:
			if animation_player.current_animation != "walk/walk":
				animation_player.play("walk/walk")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "idle/idle":
			animation_player.play("idle/idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
