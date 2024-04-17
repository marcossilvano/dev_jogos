extends CharacterBody2D
class_name PlayerShip

const SPEED: float = 400
const TURN_SPEED: float = 5
@onready var _size: Vector2 = $Sprite2D.get_rect().size
@export var _keys: Dictionary = {
	"left":  "ui_left",
	"right": "ui_right",
	"up":    "ui_up", 
	"down":  "ui_down"}

var _input: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.ZERO
var _screen_size: Vector2

func _ready() -> void:
	_screen_size = get_viewport_rect().size


func _process(_delta: float) -> void:
	#_move_4_directions(_delta)
	#_move_4_directions_nonstop(_delta)
	_move_in_any_direction(_delta)
	#_move_and_turn(_delta)


func _move_and_turn(delta: float) ->void:
	if Input.is_action_pressed(_keys["left"]):
		rotation -= TURN_SPEED * delta
	elif Input.is_action_pressed(_keys["right"]):
		rotation += TURN_SPEED * delta
		
	if Input.is_action_pressed(_keys["up"]):
		_input += Vector2.from_angle(rotation) * SPEED * delta
		#_input += Vector2(cos(rotation), sin(rotation)) * SPEED*2 * delta
	else:
		_input = _input.move_toward(Vector2.ZERO, SPEED * delta)
		#_input = _input * 0.92

	velocity = _input.limit_length(SPEED)
	move_and_slide()
	_wrap_screen()


func _move_in_any_direction(_delta: float) -> void:
	_input = Input.get_vector(_keys["left"], _keys["right"], _keys["up"], _keys["down"])

	_move_and_rotate(_delta)


func _move_4_directions_nonstop(_delta: float) -> void:
	if Input.is_action_pressed(_keys["left"]):
		_input = Vector2.LEFT
	elif Input.is_action_pressed(_keys["right"]):
		_input = Vector2.RIGHT
	elif Input.is_action_pressed(_keys["up"]):
		_input = Vector2.UP
	elif Input.is_action_pressed(_keys["down"]):
		_input = Vector2.DOWN

	_move_and_rotate(_delta)	


func _move_4_directions(_delta: float) -> void:
	_input = Vector2.ZERO
	
	if Input.is_action_pressed(_keys["left"]):
		_input.x = -1
	elif Input.is_action_pressed(_keys["right"]):
		_input.x = 1
	elif Input.is_action_pressed(_keys["up"]):
		_input.y = -1
	elif Input.is_action_pressed(_keys["down"]):
		_input.y = 1

	_move_and_rotate(_delta)
	
	
func _move_and_rotate(delta: float) -> void:
	#if _input:
	#	_direction = _input
	_direction = _direction.slerp(_input, 20.00 * delta)
	rotation = _direction.angle()
	
	velocity = _input * SPEED
	move_and_slide()
	#_wrap_screen()	


func _clamp_screen() -> void:
	position.x = clamp(position.x, _size.x/2, _screen_size.x - _size.x/2)
	position.y = clamp(position.y, _size.y/2, _screen_size.y - _size.y/2)

func _wrap_screen() -> void:
	position.x = wrap(position.x, 0, _screen_size.x)
	position.y = wrap(position.y, 0, _screen_size.y)
