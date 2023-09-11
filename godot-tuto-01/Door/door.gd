class_name Door
extends StaticBody2D

@onready var _sprite: Sprite2D = $Sprite2D

func _on_activation_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if game_controller.get_keys() > 0:
			game_controller.use_key()

			var tween: Tween = create_tween()
			tween.tween_property(_sprite, "modulate", Color.WHITE, 0.3)
			tween.tween_property(_sprite, "modulate:a", 0, 0.5)
			tween.tween_callback(queue_free)
