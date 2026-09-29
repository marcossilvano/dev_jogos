class_name Player
extends CharacterBody2D

@export var speed: float = 300
@export var acceleration: float = 900
@export var friction: float = 1500
@export var rotation_speed: float = 12

@onready var sprite_2d: Sprite2D  = $Sprite
@onready var scree_size: Vector2 = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	_move_into_direction_accel(delta)

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


func _wrap_screen() -> void:
	global_position.x = wrap(global_position.x, 0, scree_size.x)
	global_position.y = wrap(global_position.y, 0, scree_size.y)
