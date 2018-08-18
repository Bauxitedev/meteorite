extends "res://scripts/fsm/fsm_state.gd"

var main_menu = null

func on_init():
	
	main_menu = preload("res://scenes/ui/main_menu/main_menu.tscn").instance()
	add_child(main_menu)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Music.play("menu") # don't remove
	
func on_finalize():
	
	main_menu.queue_free()
	main_menu = null