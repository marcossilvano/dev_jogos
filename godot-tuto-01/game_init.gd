class_name GameInit
extends Node2D

@onready var _player: Player = $Player
@onready var _keys_ui: TextureRect = $CanvasLayer/GameUI/KeysUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# inject into game controller
	game_controller.init(_player, _keys_ui)
	_init_camera()
	
	
func _init_camera() -> void:
	var camera: Camera2D = $Player/Camera2D
	
	var map_bounds: Rect2 = _get_map_bounds($TileMap)
	
	# inject into player's camera
	camera.set_limit(Side.SIDE_LEFT, int(map_bounds.position.x))
	camera.set_limit(Side.SIDE_RIGHT, int(map_bounds.size.x + map_bounds.position.x))
	camera.set_limit(Side.SIDE_TOP, int(map_bounds.position.y))
	camera.set_limit(Side.SIDE_BOTTOM, int(map_bounds.size.y + map_bounds.position.y))


func _get_map_bounds(tilemap) -> Rect2:
	var cell_rect: Rect2 = tilemap.get_used_rect()
	var pixel_size: float = tilemap.cell_quadrant_size * tilemap.scale.x
	
	var pos := Vector2(pixel_size * cell_rect.position.x, pixel_size * cell_rect.position.y)
	var size:= Vector2(pixel_size * cell_rect.size.x, pixel_size * cell_rect.size.y)
	
	return Rect2(pos, size)	
