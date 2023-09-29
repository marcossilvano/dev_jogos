class_name GameController
extends Node2D

var _player: Player
var _camera: CameraFollow
var _keys_ui: TextureRect
var _keys: int = 0
var _keys_height: float

# PRIVATE METHODS
##################################################

func _update_hud():
	_keys_ui.set_size(Vector2(_keys_ui.get_size().x, _keys_height * _keys))


# PUBLIC METHODS
##################################################

func init(player: Player, camera: Camera2D, keys_ui: TextureRect):
	_player = player
	_keys_ui= keys_ui
	_camera = camera
	_keys_height = _keys_ui.get_size().y
	_update_hud()

	get_tree().call_group("generator", "set_player", _player)


func shake_camera(range: float, duration: float) -> void:
	_camera.shake_camera(range, duration)
	

func get_keys() -> int:
	return _keys
	

func collect_key() -> void:
	_keys += 1
	_update_hud()
	

func use_key() -> void:
	if _keys > 0:
		_keys -= 1
		_update_hud()
