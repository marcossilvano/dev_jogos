extends CharacterBody2D


const SPEED = 300.0
const ACCELERATION = 800
const FRICTION = 900
const JUMP_VELOCITY = -900.0
const JUMP_VELOCITY_MIN = JUMP_VELOCITY/3

# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var _gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direction: float = 0

func _ready() -> void:
	_gravity = 2 * _gravity
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += _gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released("ui_accept"):
		if velocity.y < JUMP_VELOCITY_MIN:
			velocity.y = JUMP_VELOCITY_MIN

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input := Input.get_axis("ui_left", "ui_right")
	if input:
		#velocity.x = input * SPEED
		velocity.x = move_toward(velocity.x, input * SPEED, ACCELERATION * delta)
		_direction = sign(input)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()
	_animate_player()
	# screen wrap
	position.x = wrap(position.x, 0, get_viewport_rect().size.x)
	position.y = wrap(position.y, 0, get_viewport_rect().size.y)



func _animate_player() -> void:
	if is_on_floor():
		_animated_sprite.speed_scale = 1
		if velocity.x != 0:
			_animated_sprite.play("run")
		else:
			_animated_sprite.play("idle")
		#_animated_sprite.rotation = 0
	else:	
		_animated_sprite.play("jump")
		if velocity.y < 0:
			_animated_sprite.speed_scale = 1
		else:
			_animated_sprite.speed_scale = -1
#		if _double_jump:
#			_animated_sprite.play("spin")
#			_animated_sprite.rotation += 0.4 * -_direction * up_direction.y
		
#	_animated_sprite.flip_h = false if _direction > 0 else true
	_animated_sprite.scale.x = _direction
#	_animated_sprite.flip_v = false if gravity > 0 else true
	#_animated_sprite.scale.y = sign(gravity)
