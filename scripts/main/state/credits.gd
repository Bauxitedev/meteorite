extends "res://scripts/fsm/fsm_state.gd"

var credits = null

func on_init():
	
	credits = preload("res://scenes/ui/main_menu/credits.tscn").instance()
	add_child(credits)
	
func on_finalize():
	
	credits.queue_free()
	credits = null