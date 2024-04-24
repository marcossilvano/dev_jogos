extends CharacterBody2D
class_name PlayerBot

const SPEED: float = 300
const ACCELERATION: float = 800
const FRICTION: float = 900
const JUMP_VELOCITY: float = -700
const JUMP_VELOCITY_MIN: float = JUMP_VELOCITY/3

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var _gravity = 980*2
var _direction = 1
var _is_double_jump: bool = false
var _start_position: Vector2
var _last_checkpoint: Checkpoint = null

func _ready() -> void:
	_start_position = position

# override
func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * delta
	#else:
	#	_is_double_jump = false
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or not _is_double_jump:
			velocity.y = JUMP_VELOCITY
			if not is_on_floor():
				_is_double_jump = true
			else:
				_is_double_jump = false
	elif Input.is_action_just_released("jump"):
		if velocity.y < JUMP_VELOCITY_MIN:
			velocity.y = JUMP_VELOCITY_MIN
	
	var input: float = Input.get_axis("ui_left", "ui_right")
	if input:
		#velocity.x = input * SPEED
		velocity.x = move_toward(velocity.x, input * SPEED, ACCELERATION * delta)
		_direction = sign(input)
	else:
		#velocity.x = 0
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	if velocity.y > 0:
		velocity.y = clamp(velocity.y, 0, 800)
	
	move_and_slide()
	_animate_player()


func _animate_player():
	if is_on_floor():
		if velocity.x != 0:
			_animated_sprite.play("run")
		else:
			_animated_sprite.play("idle")
	else:
		if velocity.y < 0:
			if _animated_sprite.animation != "jump":
				_animated_sprite.play("jump")
		else:
			if _animated_sprite.animation != "fall":
				_animated_sprite.play("fall")

	_animated_sprite.scale.x = _direction


# body entered
func _on_area_2d_body_entered(_body: Node2D) -> void:
	position = _start_position
	velocity = Vector2.ZERO
	#queue_free()
	#print(body.name)

# area entered
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Checkpoint"):
		if _last_checkpoint != null:
			_last_checkpoint._deactivate()
		area._activate()
		_start_position = area.position
		_last_checkpoint = area	
	
	elif area.is_in_group("Missle"):
		position = _start_position
