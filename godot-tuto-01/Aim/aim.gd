class_name Aim
extends Sprite2D

@export var mouse_speed: float = 1
@export var joy_speed: float = 30

var _next_pos: Vector2
var _ref_pos: Vector2
var _max_radius: float
var _min_radius: float


func _ready() -> void:
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func update_position(ref_pos: Vector2, ref_offset: Vector2) -> void:
	_get_joy_input()
#	_ref_pos = reference.get_global_position()
	_ref_pos = ref_pos
	
	var direction: Vector2 = _ref_pos - _next_pos
	var length: float = direction.length()
	if length < _min_radius or length > _max_radius:
		length = clamp(length, _min_radius, _max_radius)
		_next_pos = _ref_pos - direction.normalized() * length

	_next_pos += ref_offset
	set_global_position(_next_pos)
	queue_redraw()
	

func _draw() -> void:
	var other_pos: Vector2 = to_local(_ref_pos)
	draw_line(Vector2.ZERO, other_pos, Color(1,0,0,0.3), 1)		


func _move_pos(input_vector: Vector2, speed: float) -> void:
	var pos: Vector2 = get_global_position()
	pos += input_vector * speed
	_next_pos = pos


func _input(event):
	if OS.has_feature("mobile"):
		return
		
	# Mouse in viewport coordinates.
	if event is InputEventMouseMotion and event.relative.length() > 0.5:
		_min_radius = 50
		_max_radius = get_viewport_rect().size.y / 5
		_move_pos(event.relative, mouse_speed)


func _get_joy_input() -> void:
	var input_vector2: Vector2 = Vector2.ZERO
	input_vector2.x = Input.get_axis("axis2_left", "axis2_right")
	input_vector2.y = Input.get_axis("axis2_up", "axis2_down")
	if input_vector2.length() >= 0.3:
		_min_radius = get_viewport_rect().size.y / 5
		_max_radius = _min_radius
		_move_pos(input_vector2, joy_speed)
