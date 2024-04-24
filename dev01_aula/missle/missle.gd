extends Area2D
class_name Missle

const STEER_FORCE: float = 0.05

@export var speed: float = 300

var _velocity: Vector2 = Vector2.ZERO
var _target: Node2D
var _explosion_scn: Resource


func _ready() -> void:
	_explosion_scn = preload("res://explosion.tscn")

func launch(pos: Vector2, rot: float, target: Node2D, spd: float) -> void:
	position = pos
	rotation = rot
	#global_rotation += randf_range(-0.09, 0.09) # add a little error in direction
	_velocity = Vector2.from_angle(rot) * speed
	_target = target
	speed = spd


func _physics_process(delta: float) -> void:
	if _target:
		_velocity += (_target.position - position).normalized() * speed * STEER_FORCE
	_velocity = _velocity.limit_length(speed)
	global_rotation = _velocity.angle()
	global_position += _velocity * delta
	

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
	
	var explosion = _explosion_scn.instantiate()
	explosion.position = position
	get_parent().add_child(explosion)


func _on_timer_timeout() -> void:
	pass
	#queue_free()
