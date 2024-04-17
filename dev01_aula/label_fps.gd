extends Label
class_name LabelFPS

# override
func _process(_delta: float) -> void:
	self.text = "FPS: " + str(Engine.get_frames_per_second())
