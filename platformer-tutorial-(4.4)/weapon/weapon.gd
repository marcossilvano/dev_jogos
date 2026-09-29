class_name Weapon
extends Node2D

@export var fire_delay: float = 0.025
@export var bullets_at_screen: int = 100
@export var bullets_per_shot = 3
@export var aperture_angle: float = 20

@export_file("*.tscn") var bullet_scene: String

var _fire_counter: float = 0
var _can_fire: bool = true
var _bullets_shot: int = 0
var _bullet_resource: Resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(bullet_scene, name + ": 'bullet_scene' must be set.")
	_bullet_resource = load(bullet_scene)
	assert(_bullet_resource, name + ": error loading 'bullet_scene'.")
	aperture_angle *= PI/180

func _on_bullet_destroyed() -> void:
	_bullets_shot -= 1


func _create_bullet(direction: float) -> void:
#	print(direction * 180/PI)
	
	_can_fire = false
	_bullets_shot += 1
	
	var instance = _bullet_resource.instantiate()
	
	# setup bullet
	instance.global_position = $BulletPoint.global_position
	instance.set_velocity(500,0)
	
#	var direction: Vector2 = ($Forward.global_position - global_position).normalized()
	#instance.set_direction(direction)
	instance.rotation = direction	

	get_tree().get_root().get_child(0).call_deferred("add_child", instance)
	instance.bullet_destroyed.connect(_on_bullet_destroyed)
	

func fire_bullet() -> void:
	if _bullets_shot >= bullets_at_screen:
		return
	
	var direction: float = ($Forward.global_position - global_position).angle()
	direction -= aperture_angle/2
	
	var offset: float = 0
	if bullets_per_shot > 1:
		offset = aperture_angle / (bullets_per_shot-1)
	
	for i in range(bullets_per_shot):
		_create_bullet(direction + offset*i)


func _process(delta: float) -> void:
	_fire_counter += delta
	
	if _fire_counter >= fire_delay:
		_fire_counter -= fire_delay
		_can_fire = true
