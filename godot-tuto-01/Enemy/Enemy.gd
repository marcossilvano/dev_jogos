extends CharacterBody2D

@export var speed: float = 200

# Alternativas
#	- singleton GameController que dá acesso ao Player
#	- Generators de inimigos posicionais na cena têm atributo preenchido no editor com referência ao Player
# Solução ruim, mas simples para o momento...
@onready var player: Node = get_parent().get_node("Player")

var motion: Vector2 = Vector2()

func _physics_process(delta: float) -> void:
	motion = player.get_global_position() - get_global_position()
	motion = motion.normalized() * speed * delta
	move_and_collide(motion)
	
	look_at(player.get_global_position())
