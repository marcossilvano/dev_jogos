extends StaticBody2D
class_name Cannon

const STEER_FORCE: float = 0.01

var _missle_res: Resource
var _direction: Vector2
var _target_detected: bool = false
var _fire_counter: float = 0

#@onready var _marker: Marker2D = $Sprite/LaunchMarker
@onready var _sprite: Sprite2D = $Sprite
@onready var _particles: CPUParticles2D = $CPUParticles2D

@export var target: Node2D
@export var fire_delay: float = 1.0
@export var initial_delay: float = 0.0
@export var missle_speed: float = 300
@export_file("*.tscn") var _missle_path: String


func _ready() -> void:
	_missle_res = load(_missle_path)
	assert(_missle_res, "%s: missle path not found." % name)
	_fire_counter = 1


func _process(delta: float) -> void:
	if target:
		var target_direction = (target.position - self.position).normalized()
		_direction = _direction.slerp(target_direction, STEER_FORCE)
		_sprite.global_rotation = _direction.angle()
		#_sprite.look_at(_ship.position)
	
	if _target_detected:
		_fire_counter += delta

		if _fire_counter >= fire_delay + initial_delay:
			#initial_delay = 0
			#while _fire_counter >= fire_delay:
			_fire_counter -= fire_delay
			
			_particles.restart()
			
			var missle: Missle = _missle_res.instantiate()
			missle.launch(position, global_rotation, target, missle_speed)	
			get_parent().add_child(missle)
			
			#missle.position = get_global_mouse_position()
			#missle.launch(_marker.global_transform)
			#print(missle.global_transform)


func activate() -> void:
	_target_detected = true

	
func deactivate() -> void:
	_target_detected = false
	_fire_counter = 1


func _on_target_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_target_detected = true


func _on_target_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_target_detected = false
		_fire_counter = 1
