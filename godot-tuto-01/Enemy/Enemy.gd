class_name Enemy
extends CharacterBody2D
#extends RigidBody2D

@export var min_speed: float = 75
@export var max_speed: float = 100
@export var health: float = 1
@export var direction_error: float = 50

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _enemy_dead: PackedScene = preload("res://Enemy/enemy_dead.tscn")

var _player: Player
var _speed: float = randf_range(min_speed, max_speed)
var _motion: Vector2
var _activated: bool = true
var _tween: Tween
#var _timer: Timer

signal health_depleted


func _ready() -> void:
	_tween = create_tween()
	_tween.tween_property(_animated_sprite, "modulate:a", 0, 0.0)
	_tween.tween_property(_animated_sprite, "modulate:a", 1, 0.2)


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
	
	
#	_timer = Timer.new()
#	add_child(_timer)
#	_timer.timeout.connect(_set_motion)
#	_timer.set_wait_time(0.5)
#	_timer.set_one_shot(true)
#	_timer.start()
#	get_tree().create_timer(0.5).connect("timeout", _set_motion)
	

func _physics_process(_delta: float) -> void:
	if not _activated:
		return
	
	_motion = _player.get_global_position() - get_global_position()
	velocity = _motion.normalized() * _speed
	move_and_slide()
	
	if _motion.length() < 80:
		_animated_sprite.play("attack")
	else:
		_animated_sprite.play("move")
		
	look_at(_player.get_global_position())


func _physics_process_old(delta: float) -> void:
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


func _kill():
	emit_signal("health_depleted")
	queue_free()
	var _body: EnemyDead = _enemy_dead.instantiate()
	_body.position = position
	_body.rotation = rotation
	_body.scale = scale
	get_parent().add_child(_body)


func _hit(body: Bullet):
	health -= body.damage
	
	if _tween:
		_tween.stop()
	_tween = create_tween()
	_tween.tween_property(_animated_sprite, "modulate", Color.RED, 0.0)
	_tween.tween_property(_animated_sprite, "modulate", Color.WHITE, 0.1)
	
	if health <= 0:
		_kill()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		_hit(body)
