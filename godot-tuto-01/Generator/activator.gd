#
# Activates every Generator nested inside the same parent node as this Activator.
#
class_name Activator
extends Area2D

@export var generators: Array[Generator]

func _ready() -> void:
	# get access to all generators in its group
	for node in get_parent().get_children():
		if node is Generator:
			generators.append(node)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		for gen in generators:
			if gen != null:
				gen.activate()
	
		# destroy itself, because it's not needed anymore
		queue_free()
