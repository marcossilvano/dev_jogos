# Coletor simples de items que contenham Area2D
# 
# Configuração de Collision
#    Layer: ---
#    Mask : Item
#
# Sinal
#    Lança signal "item_collected" ao intersectar com área 2D

extends Area2D
class_name ItemCollector

var _total_items: int = 0

signal item_collected(item: Item)

func _on_area_entered(item: Item) -> void:
	item.queue_free()
	item_collected.emit(item)
	_total_items += item.get_value()
	gc.update_hud_items(_total_items)
