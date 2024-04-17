extends Area2D
class_name Checkpoint

func _activate() -> void:
	$Sprite2D.frame = 1
	
	
func _deactivate() -> void:
	print("deactivate")
	$Sprite2D.frame = 0
