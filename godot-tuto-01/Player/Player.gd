# Player editor:
# 	Set "Group" to "player" on Node tab
class_name Player
extends CharacterBody2D

@export var aim: Aim
@export var max_speed: float = 200
@export var acceleration: float = 70
@export var bullet_speed: float = 500
@export var fire_delay: float = 0.1
@export var fire_error: float = 0.04


var _bullet_res: Resource = preload("res://Bullet/bullet.tscn")
var _input_vector: Vector2 = Vector2.ZERO
var _can_fire = true
#var _direction: Vector2 = Vector2.ZERO
var _old_position: Vector2


func _ready() -> void:
	assert(aim, name + ": 'aim' object not set.")


#func _input(event):
#	# Mouse in viewport coordinates.
#	if event is InputEventMouseMotion:
#		if event.relative.length() >= 0.3:
#			_direction += event.relative
#
#
#func _look_at_aim(player_offset: Vector2) -> void:
#	var aim_pos: Vector2 = aim.get_global_position()
#	aim_pos += player_offset
#	aim.set_global_position(aim_pos)
#	look_at(aim.get_global_position())
#
#
#func _look_at_sight() -> void:
#	var input_vector2: Vector2 = Vector2.ZERO
#	input_vector2.x = Input.get_axis("axis2_left", "axis2_right")
#	input_vector2.y = Input.get_axis("axis2_up", "axis2_down")
##	if input_vector2 != Vector2.ZERO:
#	if input_vector2.length() >= 0.3:
#		_direction += input_vector2
#		_direction = _direction.normalized()	
#	rotation = _direction.angle()


func _process(_delta: float) -> void:
	aim.update_position(self, get_global_position() - _old_position)
	_old_position = get_global_position()


func _mobile_fire() -> bool:
	var right_stick: Vector2 = Vector2.ZERO
	right_stick.x = Input.get_axis("axis2_left", "axis2_right")
	right_stick.y = Input.get_axis("axis2_up", "axis2_down")
	
	return right_stick != Vector2.ZERO# and OS.has_feature("mobile")	


func _physics_process(_delta):
	_input_vector.x = Input.get_axis("ui_left", "ui_right")
	_input_vector.y = Input.get_axis("ui_up", "ui_down")
	_input_vector = _input_vector.normalized()
#	rotation = _input_vector.angle()
	
	if _input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(_input_vector * max_speed, acceleration)
		#velocity = _input_vector * max_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, max_speed)

	move_and_slide()

	# shooting direction
	look_at(aim.get_global_position())
	
	# shooting
	if (Input.is_action_pressed("fire") or _mobile_fire()) and _can_fire:
		_fire_bullet()
		
		_can_fire = false
		await get_tree().create_timer(fire_delay).timeout
		_can_fire = true


func _fire_bullet():
	var bullet = _bullet_res.instantiate()
	bullet.position = $BulletPoint.get_global_position()
	bullet.rotation = rotation
	bullet.apply_impulse(Vector2(bullet_speed,0).rotated(global_rotation + randf_range(-fire_error,fire_error)), Vector2())
	#get_tree().get_root().call_deferred("add_child", bullet)
	get_tree().get_root().add_child(bullet)


func _hit():
	pass
	#get_tree().reload_current_scene()


func _on_hit_box_body_entered(body):
	if body.is_in_group("enemy"):
		_hit()
