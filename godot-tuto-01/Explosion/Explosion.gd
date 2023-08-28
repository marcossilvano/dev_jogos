# AnimatedSprite editor:
# 	Use "Add frames from spritesheet" to load frames from explosion.png
# 	Enable "AutoPlayOnLoad"
#	Connect "animationFinished()" signal

extends AnimatedSprite2D

func _on_animation_finished() -> void:
	queue_free()
