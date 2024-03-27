extends Sprite2D
class_name ScrollingBackground

@export var speed: float = 32
@export var voffset: float = 0

func _ready() -> void:
	region_rect.position.y = voffset


func _process(delta: float) -> void:
	region_rect.position.x += speed * delta
