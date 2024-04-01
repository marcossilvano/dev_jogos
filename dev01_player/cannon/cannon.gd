extends Area2D
class_name Cannon

const STEER_FORCE: float = 0.01

var _missle_res: Resource
var _direction: Vector2
@onready var _marker: Marker2D = $Sprite/LaunchMarker
@onready var _sprite: Sprite2D = $Sprite

@export var _ship: PlayerShip
@export_file("*.tscn") var _missle_path: String


func _ready() -> void:
	assert(_ship, "%s: player reference must be set." % name)
	_missle_res = load(_missle_path)
	assert(_missle_res, "%s: missle path not found." % name)


func _process(_delta: float) -> void:
	var target_direction = (_ship.position - self.position).normalized()
	_direction = _direction.slerp(target_direction, STEER_FORCE)
	_sprite.global_rotation = _direction.angle()
	#_sprite.look_at(_ship.position)
	
	if Input.is_action_just_pressed("mouse_left_button"):
		var missle: Missle = _missle_res.instantiate()
		missle.launch(_marker.global_position, _marker.global_rotation, _ship)
		
		get_parent().add_child(missle)
		
		#missle.position = get_global_mouse_position()
		#missle.launch(_marker.global_transform)
		#print(missle.global_transform)

'''
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("Left button was clicked at ", event.position)
				var missle = _missle_res.instantiate()
				missle.position = event.position
				add_child(missle)
				# instantiate missle
			#else:
			#	print("Left button was released")
		#if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		#	print("Wheel down")
'''
