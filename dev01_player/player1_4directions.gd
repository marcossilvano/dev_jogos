extends CharacterBody2D
class_name Player4Directions

enum MovementTypes {
	FOUR_DIRECTIONS, 
	FOUR_DIRECTIONS_CONTINUOUSLY, 
	ANY_DIRECTION, 
	TURN_AND_FORWARD
}

@export var keys: Dictionary = {"left": "ui_left", "right": "ui_right", "up": "ui_up", "down": "ui_down"}
@export var movement_type: MovementTypes
@export var speed: float = 400

var _screen_size: Vector2
var _input: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.ZERO
var _move_function: Callable

@onready var _sprite: Sprite2D = $Sprite
@onready var _emitter: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	_screen_size = get_viewport_rect().size

	var move_functions: Array = [_move_in_four_directions, _move_in_four_directions_continuously, 
								 _move_in_any_direction, _move_turn_and_forward]
	_move_function = move_functions[movement_type]	


func _move_in_four_directions(delta: float) -> void:
	_input = Vector2.ZERO
	
	if Input.is_action_pressed(keys["left"]):
		_input.x = -1
	elif Input.is_action_pressed(keys["right"]):
		_input.x = 1
	elif Input.is_action_pressed(keys["up"]):
		_input.y = -1
	elif Input.is_action_pressed(keys["down"]):
		_input.y = 1
		
	#rotation = _input.angle()
	_direction = _direction.slerp(_input, 0.15)
	rotation = _direction.angle()
	
	velocity = _input * speed
	#position += velocity * delta
	move_and_slide()
	
	if _input:
		_emitter.emitting = true
	else:
		_emitter.emitting = false
	
	#position = position.clamp(Vector2.ZERO, _screen_size)
	#_clamp_screen()
	_wrap_screen()		


func _move_in_four_directions_continuously(delta: float) -> void:
	if Input.is_action_pressed(keys["left"]):
		_input = Vector2(-1,0)
	elif Input.is_action_pressed(keys["right"]):
		_input = Vector2(1,0)
	elif Input.is_action_pressed(keys["up"]):
		_input = Vector2(0,-1)
	elif Input.is_action_pressed(keys["down"]):
		_input = Vector2(0,1)

	#rotation = _input.angle()
	_direction = _direction.slerp(_input, 0.15)
	rotation = _direction.angle()
	
	velocity = _input * speed
	#position += velocity * delta
	move_and_slide()
	
	#position = position.clamp(Vector2.ZERO, _screen_size)
	#_clamp_screen()
	_wrap_screen()


func _move_in_any_direction(delta: float) -> void:
	_input = Input.get_vector(keys["left"], keys["right"], keys["up"], keys["down"])

	_direction = _direction.slerp(_input, 0.15)
	rotation = _direction.angle()
	
	velocity = _input * speed
	#position += velocity * delta
	move_and_slide()
	
	if _input:
		_emitter.emitting = true
	else:
		_emitter.emitting = false
	
	#position = position.clamp(Vector2.ZERO, _screen_size)
	#_clamp_screen()
	_wrap_screen()


func _move_turn_and_forward(delta: float) -> void:
	if Input.is_action_pressed(keys["left"]):
		rotation -= 5 * delta
	elif Input.is_action_pressed(keys["right"]):
		rotation += 5 * delta

	if Input.is_action_pressed(keys["up"]):
		_input += Vector2.from_angle(rotation) * 800 * delta
		_emitter.emitting = true
	else:
		_input = _input.move_toward(Vector2.ZERO, 400*delta)
		#speed *= 0.98
		_emitter.emitting = false
		
	velocity = _input.limit_length(400)
	move_and_slide()
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision:
		print("angle:", collision.get_angle())
		print("depth:", collision.get_depth())
	
	_wrap_screen()	
	

func _process(delta: float) -> void:
	_move_function.call(delta)

#	if _input.length() > 1:
#		_input = _input.normalized()

	#var angle: int = int(_input.angle() * 180/PI)
	#if _input:
	#	rotation = _input.angle()
	

func _clamp_screen() -> void:
	var half: Vector2 = _sprite.get_rect().size/2
	position.x  = clamp(position.x, half.x, _screen_size.x - half.x)
	position.y  = clamp(position.y, half.y, _screen_size.y - half.y)


func _wrap_screen() -> void:
	#var half: Vector2 = _sprite.get_rect().size/2
	position.x  = wrap(position.x, 0, _screen_size.x)
	position.y  = wrap(position.y, 0, _screen_size.y)
