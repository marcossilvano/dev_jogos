# RigidBody2D editor:
# 	Set "Max Contacts Reported" to 1
#	Enable "Contact Monitor"
#	Connect "bodyEntered()" signal
class_name Bullet
extends RigidBody2D

@export var damage: float = 1
@export var life_time: float = 0.5

@onready var _sprite: Sprite2D = $Sprite2D

var _explosion_res = preload("res://Explosion/explosion.tscn")


func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(_sprite, "modulate:a", 0, life_time)
	tween.tween_callback(queue_free)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		var explosion = _explosion_res.instantiate()
		explosion.position = get_global_position()
		get_tree().get_root().add_child(explosion)
		queue_free()
