extends CPUParticles2D
class_name Explosion

func _ready() -> void:
	emitting = true

func _on_finished():
	queue_free()
