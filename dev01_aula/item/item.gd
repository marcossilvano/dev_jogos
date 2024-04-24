extends Area2D
class_name Item

@onready var _player: AnimationPlayer = $AnimationPlayer

@export var value: int = 5

# create an animation offset by x global_position
func _ready() -> void:
	var offset: int = int(global_position.x) % 10
	_player.seek( (_player.current_animation_length / 10) * offset)


func get_value() -> int:
	return value
