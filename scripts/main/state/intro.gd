extends "res://scripts/fsm/fsm_state.gd"

var intro = null

func on_init():
	
	intro = preload("res://scenes/ui/intro.tscn").instance()
	add_child(intro)
	
func on_finalize():
	
	intro.queue_free()
	intro = null
