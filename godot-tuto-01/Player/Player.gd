# Player editor:
# 	Set "Group" to "player" on Node tab

extends CharacterBody2D

@export var max_speed: float = 400
@export var acceleration: float = 70
@export var bullet_speed: float = 2000
@export var fire_delay: float = 0.1
@export var fire_error: float = 0.05

var bullet_res: Resource = preload("res://Bullet/bullet.tscn")
var input_vector: Vector2 = Vector2.ZERO
var can_fire = true

func _physics_process(_delta):
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration)
		#velocity = input_vector * max_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, max_speed)

	move_and_slide()

	# shooting	
	look_at(get_global_mouse_position())
	# if Input.is_action_just_pressed("fire"):
	if Input.is_action_pressed("fire") and can_fire:
		fire_bullet()
		
		can_fire = false
		var timer: SceneTreeTimer = get_tree().create_timer(fire_delay)
		await timer.timeout
		can_fire = true

func fire_bullet():
	var bullet = bullet_res.instantiate()
	bullet.position = $BulletPoint.get_global_position()
	bullet.rotation = rotation
	bullet.apply_impulse(Vector2(bullet_speed,0).rotated(global_rotation + randf_range(-fire_error,fire_error)), Vector2())
	#get_tree().get_root().call_deferred("add_child", bullet)
	get_tree().get_root().add_child(bullet)

func hit():
	get_tree().reload_current_scene()
