class_name Key
extends Area2D

@onready var _sprite: Sprite2D = $Sprite2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		game_controller.collect_key()
		
		# disable collisions
		$CollisionShape2D.queue_free()
		
		var tween: Tween = create_tween()
#		tween.tween_property(_sprite, "modulate", Color.BLUE, 0.0)
		tween.tween_property(_sprite, "modulate:a", 0, 0.5)
		tween.tween_callback(queue_free)
