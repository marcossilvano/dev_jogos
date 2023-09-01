extends Node2D

@onready var _player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().call_group("enemy", "set_player", _player)
