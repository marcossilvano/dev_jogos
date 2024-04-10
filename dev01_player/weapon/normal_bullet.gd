class_name NormaBullet
extends Area2D

signal bullet_destroyed

var _velocity: Vector2
#var _direction: Vector2

#func set_direction(direction: Vector2) -> void:
#	_direction = direction


func set_velocity(vel_x: float, vel_y: float) -> void:
	_velocity = Vector2(vel_x, vel_y)


func _process(delta: float) -> void:
	global_position += (_velocity * delta).rotated(rotation)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	emit_signal("bullet_destroyed")
	queue_free()
