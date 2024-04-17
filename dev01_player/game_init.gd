class_name GameInit
extends Node2D

#@onready var _player: PlayerBot = $PlayerBot1
@onready var _camera: CameraShake = $PlayerBot1/Camera2D
#@onready var _keys_ui: TextureRect = $CanvasLayer/GameUI/KeysUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# inject into game controller
#	game_controller.init(_player, _camera, _keys_ui)
	_camera.init_camera_limits(_get_map_bounds($TileMap))

	
func _get_map_bounds(tilemap: TileMap) -> Rect2:
	var map_rect: Rect2 = tilemap.get_used_rect()
	var cell_width: float = tilemap.tile_set.tile_size.x * tilemap.scale.x
	
	var pos := map_rect.position * cell_width
	var size:= map_rect.size * cell_width
	
	return Rect2(pos, size)	
