extends Node2D
class_name GameInit

@onready var _camera: CameraUtils = $PlayerBot/Camera2D

func _ready() -> void:
	_camera.init_camera_limits(_get_map_bounds($TileMap))


func _get_map_bounds(tilemap: TileMap) -> Rect2:
	# obtem o retangulo do mapa em celulas
	var map_rect: Rect2 = tilemap.get_used_rect()
	var cell_size: float = tilemap.tile_set.tile_size.x * tilemap.scale.x
	
	var pos := map_rect.position * cell_size
	var size:= map_rect.size * cell_size
	
	return Rect2(pos, size)
