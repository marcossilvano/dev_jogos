class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite_2d: Sprite2D  = $Sprite
@onready var scree_size: Vector2 = get_viewport_rect().size

var double_jump: bool = false

func _physics_process(delta: float) -> void:
	# add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		double_jump = false

	# handle jump
	if Input.is_action_just_pressed("ui_jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif not double_jump:
			velocity.y = JUMP_VELOCITY
			double_jump = true

	# movement input
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# apply movement
	move_and_slide()
	_wrap_screen()


func _wrap_screen() -> void:
	global_position.x = wrap(global_position.x, 0, scree_size.x)
	global_position.y = wrap(global_position.y, 0, scree_size.y)
