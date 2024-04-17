extends Node2D
class_name SceneController

const SCENE_IMAGES: String = "res://scene_images/"

@export_file("*.json") var dialog_path: String = ""
@export var text_delay: float = 0.03

var _dialog: Variant
var _current_phrase: int = 0
var _free_when_finished: bool = false
var _current_idx: int = -1
var _lock_scene: bool = false

@onready var _scene_text: RichTextLabel = $CanvasLayer/PanelScene/RichTextLabel
@onready var _options_text: RichTextLabel = $CanvasLayer/PanelOptions/RichTextLabel
@onready var _outcome_text: RichTextLabel = $CanvasLayer/PanelOutcome/RichTextLabel
@onready var _sprite: Sprite2D = $Sprite2D

# PRIVATE METHODS ###########################################

func _ready() -> void:
	# carregar a primeira cena do arquivo json
	_dialog = _get_dialog()
	print(name + ": init dialog. File '" + dialog_path + "' loaded")
	_show_scene("first_scene")	


func _get_scene_index(key: String) -> int:
	var idx = -1
	for i in range(len(_dialog)):
		if _dialog[i]["key"] == key:
			idx = i
			break

	if idx == -1:
		printerr(name + ": invalid scene key: " + key)

	return idx


func _fill_options(idx: int) -> void:
	_options_text.text = ""
	var options = _dialog[idx]["options"]
	
	var label:int = 1
	for opt in options:
		_options_text.text += str(label) + "-" + opt["text"] + "\n\n" 
		label += 1


func _load_scene_image(scene_key: String) -> void:
	var image_path = "%s/%s.png" % [SCENE_IMAGES, scene_key]
	
	var image := Image.load_from_file(image_path)
	_sprite.texture = ImageTexture.create_from_image(image)
	#_sprite.centered = false


func _show_scene(key: String) -> void:
	_current_idx = _get_scene_index(key)
	if _current_idx == -1:
		return
	
	# mostra título e texto
	_scene_text.text = _dialog[_current_idx]["title"].to_upper() + "\n\n" + _dialog[_current_idx]["text"]
	
	# carrega o sprite da cena
	_load_scene_image(_dialog[_current_idx]["key"])
	
	# mostra opções
	_fill_options(_current_idx)


func _reset() -> void:
	visible = false
	_current_phrase = 0
	set_process(false)

	if _free_when_finished:
		queue_free()		
	

func _get_dialog() -> Array:
	# check of condition is true or crash the game with the error message
	assert(FileAccess.file_exists(dialog_path), "%s: json file does not exist" % name)
	
	# extract data from file
	var file: FileAccess = FileAccess.open(dialog_path, FileAccess.READ)
	var json: String = file.get_as_text()

	var test_json_conv = JSON.new()
	test_json_conv.parse(json)
	var output = test_json_conv.get_data()
	#print(JSON.stringify(output, "\t"))
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []


func select_option(opt: int):
	if _lock_scene:
		return
	
	var options = _dialog[_current_idx]["options"]
	if opt < 0 or opt >= len(options):
		return
	# mostra o resultado da escolha
	_outcome_text.text = options[opt]["outcome"]
	
	_lock_scene = true
	await get_tree().create_timer(1.5).timeout
	_lock_scene = false
	
	# carregar a outra cena, se for o caso
	_outcome_text.text = ""
	var next_scene = options[opt]["next"]
	if next_scene != "none":
		_show_scene(options[opt]["next"])


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:# and event.keycode == KEY_ESCAPE:
			select_option(event.keycode - 49)	
			print(event.keycode)
