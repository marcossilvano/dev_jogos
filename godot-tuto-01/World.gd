class_name World
extends Node2D

@onready var _player: Player = $Player
@onready var _keys_ui: TextureRect = $GameUI/CanvasLayer/KeysUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# inject into game controller
	game_controller.init(_player, _keys_ui)
