# Simulate touch events with mouse:
#
# Project Settings
#    Input Devices
#       Pointing:
#          Generate touch from mouse: ON

class_name VirtualJoystick2
extends Node2D

@onready var _base: TouchScreenButton = $JoystickBase
@onready var _point: Sprite2D = $JoystickBase/JoystickPoint

var _radius: Vector2
var _input_vector: Vector2 = Vector2.ZERO
var _active: bool = false
var _touch_id: int = -1


func _ready() -> void:
	_radius.x = _base.shape.radius * _base.scale.x
	_radius.y = _base.shape.radius * _base.scale.y
	_point.visible = true
	#_point.scale = _point.scale * scale
	
	
func _inside_joystick(pos: Vector2) -> bool:
	return pos.distance_to(_radius + _base.global_position) <= _radius.x
	

func _input(event: InputEvent) -> void:
	# when the first touch is made, we store the index
	if event is InputEventScreenTouch and _inside_joystick(event.position) and _touch_id == -1:
		_touch_id = event.index				
	
	if (event is InputEventScreenTouch and _touch_id != -1) or event is InputEventScreenDrag:
		if event.index != _touch_id:
			return
			
		if _base.is_pressed():				
			_input_vector = _calculate_move_vector(event.position)
			_active = true
			_point.global_position = event.position
			_point.visible = true
			_generate_input_events()
			
			# the point cannot move beyond the joystick radius
			if not _inside_joystick(event.position):
				_point.global_position = _input_vector * _radius + _radius + _base.global_position
			

	if event is InputEventScreenTouch:
		if event.index != _touch_id:
			return
			
		if not event.pressed:
			_active = false
			_input_vector = Vector2.ZERO
			_point.visible = false
			_touch_id = -1	
			_generate_input_events()


func _new_input(action: String, strength: float) -> void:
	var ev: InputEventAction = InputEventAction.new()
	ev.action = action
	ev.strength = strength
	ev.pressed = true
	Input.parse_input_event(ev)	


func _generate_input_events() -> void:
	var strength: float = 0
		
	strength = _input_vector.x if _input_vector.x >= 0 else 0.0
	_new_input("ui_right", strength)

	strength = -_input_vector.x if _input_vector.x < 0 else 0.0
	_new_input("ui_left", strength)

	strength = -_input_vector.y if _input_vector.y < 0 else 0.0
	_new_input("ui_up", strength)

	strength = _input_vector.y if _input_vector.y >= 0 else 0.0
	_new_input("ui_down", strength)


#func _process(delta: float) -> void:
#	if _active:
#		_generate_input_events()
#		emit_signal("on_stick_moved", move_vector)


func _calculate_move_vector(event_position) -> Vector2:
	var texture_center = _base.global_position + _radius
	return (event_position - texture_center).normalized()


# external access method
func get_input_vector() -> Vector2:
	return _input_vector
	
