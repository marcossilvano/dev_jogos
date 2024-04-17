extends Node
class_name Gamecontroller

var _label_item: LabelItems = null
var _total_items: int = 0

func _ready() -> void:
	_label_item = $/root/World/CanvasLayerHUD/LabelItems

func update_hud_items(value: int) -> void:
	_label_item.update_value(value)
