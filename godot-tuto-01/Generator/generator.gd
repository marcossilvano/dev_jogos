class_name Generator
extends StaticBody2D

@export var health: float = 10
@export var rotation_speed: float = 2
@export var generation_delay: float = 1.5
@export var initial_delay: bool = false
@export var enemy_limit: int = 5
@export_file("*.tscn") var entity_scene: String

@onready var _sprite: Sprite2D = $Sprites/Sprite2D3

var _sprites: Array[Sprite2D]
var _entity_res: Resource
var _timer: Timer
var _player: Player
var _active: bool = false
var _tween: Tween
var _enemy_count: int = 0


func _ready() -> void:
	# get access to all sprites
	for spr in $Sprites.get_children():
		_sprites.append(spr)
	
	assert(entity_scene, name + ": 'entity' must be set.")
	_entity_res = load(entity_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var offset: float = 0
	var i: int = 0
	for spr in _sprites:
		spr.rotation += (rotation_speed + offset) * delta
		
		if i != 0: # shadow doesn't rotate faster
			offset += 0.5
		i += 1


func _generate_entity():
	if _enemy_count >= enemy_limit:
		return
	
	var instance = load(entity_scene).instantiate()
	instance.position = get_global_position()
	instance.set_player(_player)
	get_parent().call_deferred("add_child", instance)
	
	_enemy_count += 1
	instance.health_depleted.connect(_on_enemy_killed)

#	get_tree().create_timer(generation_delay).call("_generate_entity")


func _on_enemy_killed():
	_enemy_count -= 1


func _hit(body: Bullet):
	health -= body.damage

	if _tween:
		_tween.stop()
	_tween = create_tween()
	_tween.tween_property(_sprite, "modulate", Color.RED, 0.0)
	_tween.tween_property(_sprite, "modulate", Color.WHITE, 0.1)

	if health <= 0:
		queue_free()


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("bullet"):
		_hit(body)
		

## PUBLIC METHODS ######################################
########################################################

# dependency injection
# need player's instance to set on every generated enemy
func set_player(instance: Player) -> void:
	_player = instance


# player entered area and this generator should be activated
func activate() -> void:
	if _active: 
		return
		
	_active = true
	_timer = Timer.new()
	add_child(_timer)
	_timer.timeout.connect(_generate_entity)
	_timer.set_wait_time(generation_delay)
	_timer.set_one_shot(false)
	_timer.start()
	
	if not initial_delay:
		_generate_entity()	
