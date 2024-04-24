#
# Activates every Generator nested inside the same parent node as this Activator.
#
extends Area2D
class_name Activator

@export var destroy_on_activate: bool = false
var _activatables: Array[Node2D]

func _ready() -> void:
	# get access to all generators in its group
	for node in get_parent().get_children():
		if not (node is Activator):
			_activatables.append(node)
			assert(node.has_method("activate"), name + ": activatable nodes have to have an 'activate()' method.")
			assert(node.has_method("deactivate"), name + ": activatable nodes have to have a 'deactivate()' method.")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		for gen in _activatables:
			if gen != null:
				gen.activate()
	
	# destroy itself, because it's not needed anymore
	if destroy_on_activate:
		queue_free()


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		for gen in _activatables:
			if gen != null:
				gen.deactivate()
