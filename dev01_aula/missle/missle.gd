extends Area2D
class_name Missle

const STEER_FORCE: float = 0.05

@export var homming: bool = false
@export var speed: float = 300

var _velocity: Vector2 = Vector2.ZERO
var _target: Node2D


#func launch(trans: Transform2D) -> void:
func launch(pos: Vector2, rot: float, target: Node2D) -> void:
	global_position = pos
	global_rotation = rot
	rotation += randf_range(-0.09, 0.09) # add a little error in direction
	_velocity = Vector2.from_angle(rot) * speed
	_target = target
	#global_transform = trans
	#_velocity = transform.x * SPEED


func _physics_process(delta: float) -> void:
	if _target:
		_velocity += (_target.position - position).normalized() * speed * STEER_FORCE
	_velocity = _velocity.limit_length(speed)
	rotation = _velocity.angle()
	position += _velocity * delta
	

func _on_body_entered(_body: Node2D) -> void:
	queue_free()


func _on_timer_timeout() -> void:
	pass
	#queue_free()
