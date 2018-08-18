extends CanvasLayer

# This is purely a container for Dialogs.
# It can be used to detect if there are any open dialogs at the moment.

	
func add_text_dialog(texts):
	
	if any_dialog_open():
		print("there's already another dialog open")
		return
		
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var dialog = preload("res://scenes/ui/dialogue.tscn").instance()
	dialog.init(texts)
	add_child(dialog)
	
func remove_dialog(dialog):
	
	dialog.hide() # important
	dialog.queue_free()
		
	if !any_dialog_open():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
		

func add_pause_dialog():
	
	if any_dialog_open():
		print("there's already another dialog open")
		return
		
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var dialog = preload("res://scenes/ui/pause.tscn").instance()
	add_child(dialog)

func any_dialog_open():
	for c in get_children():
		if c.visible:
			return true
	return false
