class_name Enemy
extends CharacterBody2D
#extends RigidBody2D

@export var min_speed: float = 50
@export var max_speed: float = 150
@export var health: float = 5
@export var direction_error: float = 50

var _player: Player
var _speed: float = randf_range(min_speed, max_speed)
var _motion: Vector2
var _activated: bool = false


# dependency injection
func set_player(instance: Player) -> void:
	_player = instance
	_set_motion()


func _set_motion() -> void:
	var distance: float = position.distance_to(_player.get_global_position())
	
	if distance < 150: 
		_activated = true
		
	if distance < 64: 
		# go straight to player
		_motion = (_player.get_global_position()) - get_global_position()
	else:
		# move with error
		var error := Vector2(
			randf_range(-direction_error, direction_error), randf_range(-direction_error, direction_error))
		_motion = (_player.get_global_position() + error) - get_global_position()
	
	get_tree().create_timer(0.5).connect("timeout", _set_motion)
	
	
func _physics_process(delta: float) -> void:
	if not _activated:
		return
	
	if not _player:
		printerr(name + ": Player instance not found.")
		return

	_motion = _motion.normalized() * _speed * delta
	move_and_collide(_motion)
	#apply_force(motion * 10)
	#linear_velocity = linear_velocity.normalized() * speed
	
	look_at(_player.get_global_position())

func _hit(body: Bullet):
	health -= body.damage
	if health <= 0:
		queue_free()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		_hit(body)
