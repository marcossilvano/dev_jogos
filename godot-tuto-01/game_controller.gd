class_name GameController
extends Node2D

var _player: Player
var _keys_ui: TextureRect
var _keys: int = 0
var _keys_height: float


func init(player: Player, keys_ui: TextureRect):
	_player = player
	_keys_ui= keys_ui
	_keys_height = _keys_ui.get_size().y
	_update_hud()

	get_tree().call_group("generator", "set_player", _player)


func _update_hud():
	_keys_ui.set_size(Vector2(_keys_ui.get_size().x, _keys_height * _keys))


func get_keys():
	return _keys


func collect_key():
	_keys += 1
	_update_hud()

func use_key():
	if _keys > 0:
		_keys -= 1
		_update_hud()
