extends Label
class_name LabelItems

var _items: int = 0

func _ready() -> void:
	update_value(0)

func update_value(value: int) -> void:
	_items = value
	self.text = "Items: %04d" % _items
