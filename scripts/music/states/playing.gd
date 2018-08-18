extends "res://scripts/fsm/fsm_state.gd"

func on_init():
	if !fsm_owner.is_queue_empty():
		fsm_owner.pop_queue()

func play(name):
	fsm_owner.enqueue(name)
	fsm_owner.pop_queue()