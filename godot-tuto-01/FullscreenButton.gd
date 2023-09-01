extends Button

var _is_full_screen = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		_toggle_fullscreen()


func _on_pressed() -> void:
	_toggle_fullscreen()


func _toggle_fullscreen() -> void:
	_is_full_screen = not _is_full_screen
	
	if _is_full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)	
