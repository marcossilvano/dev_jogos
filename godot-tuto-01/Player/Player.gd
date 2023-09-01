# Player editor:
# 	Set "Group" to "player" on Node tab
class_name Player
extends CharacterBody2D

@export var max_speed: float = 200
@export var acceleration: float = 70
@export var bullet_speed: float = 500
@export var fire_delay: float = 0.1
@export var fire_error: float = 0.08

var _bullet_res: Resource = preload("res://Bullet/bullet.tscn")
var _input_vector: Vector2 = Vector2.ZERO
var _can_fire = true

func _physics_process(_delta):
	_input_vector.x = Input.get_axis("ui_left", "ui_right")
	_input_vector.y = Input.get_axis("ui_up", "ui_down")
	_input_vector = _input_vector.normalized()
	
	if _input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(_input_vector * max_speed, acceleration)
		#velocity = _input_vector * max_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, max_speed)

	move_and_slide()

	# shooting	
	look_at(get_global_mouse_position())
	# if Input.is_action_just_pressed("fire"):
	if Input.is_action_pressed("fire") and _can_fire:
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
