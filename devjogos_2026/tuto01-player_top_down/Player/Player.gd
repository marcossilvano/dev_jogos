class_name Player
extends CharacterBody2D

@export var speed: float = 300
@export var acceleration: float = 900
@export var friction: float = 1500
@export var rotation_speed: float = 12

@export var thrust: float = 400
@export var drag: float = 15
@export var turn_speed: float = 3.5
@export var max_speed: float = 500

#@onready var sprite_2d: Sprite2D = $Sprite
@onready var sprite_2d: Sprite2D  = $Sprite
@onready var scree_size: Vector2 = get_viewport_rect().size

var update_func: Callable = _move_into_direction


func _physics_process(delta: float) -> void:
	# select control mode
	if Input.is_action_just_pressed("ui_mode1"):
		update_func = _move_into_direction
	elif Input.is_action_just_pressed("ui_mode2"):
		update_func = _move_into_direction_accel
	elif Input.is_action_just_pressed("ui_mode3"):
		update_func = _move_into_direction_accel2
	elif Input.is_action_just_pressed("ui_mode4"):
		update_func = _rotate_and_move

	update_func.call(delta)
	#_move_into_direction(delta)


func _move_into_direction(delta: float) -> void:
	# get input and move
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# apply movement
	velocity = input_direction * speed
	move_and_slide()
	
	# rotate sprite
	if input_direction != Vector2.ZERO:
		sprite_2d.rotation = lerp_angle(sprite_2d.rotation, input_direction.angle(), rotation_speed * delta)
		
	_wrap_screen()


func _move_into_direction_accel(delta: float) -> void:
	# get input and move
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# apply movement
	# velocity = direction * SPEED
	var rate: float = acceleration if input_direction != Vector2.ZERO else friction
	velocity = velocity.move_toward(input_direction * speed, rate * delta)
	move_and_slide()
	
	# rotate sprite
	if input_direction != Vector2.ZERO:
		sprite_2d.rotation = lerp_angle(sprite_2d.rotation, input_direction.angle(), rotation_speed * delta)
		
	_wrap_screen()


func _move_into_direction_accel2(delta: float) -> void:
	# get input and move
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# apply movement
	# velocity = direction * SPEED
	if input_direction != Vector2.ZERO:
		velocity += input_direction * acceleration * delta
	else:
		velocity *= 0.95

	if velocity.length() > max_speed:
		velocity.limit_length(max_speed)

	move_and_slide()
	
	# rotate sprite
	if input_direction != Vector2.ZERO:
		sprite_2d.rotation = lerp_angle(sprite_2d.rotation, input_direction.angle(), rotation_speed * delta)
		
	_wrap_screen()


func _rotate_and_move(delta: float) -> void:
	# steer left/right
	var turn_input: float = Input.get_axis("ui_left", "ui_right")
	rotation += turn_input * turn_speed * delta

	# thrust into direction
	if Input.is_action_pressed("ui_up"):
		# Vector2.from_angle(rotation) or transform.x gets the forward vector (assumes sprite faces Right at 0 rad)
		var forward: Vector2 = Vector2.from_angle(rotation)
		velocity += forward * thrust * delta
		velocity = velocity.limit_length(max_speed)
	else:
		# space drag / slow inertia decay
		velocity = velocity.move_toward(Vector2.ZERO, drag * delta)

	move_and_slide()
	_wrap_screen()


func _wrap_screen() -> void:
	global_position.x = wrap(global_position.x, 0, scree_size.x)
	global_position.y = wrap(global_position.y, 0, scree_size.y)
