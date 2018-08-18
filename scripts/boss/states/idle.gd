extends "res://scripts/fsm/fsm_state.gd"

var last_state = null

func on_init():
	print("idle")
	$timer.start()
	# don't init last_state here (need to remember across state changes)
	
func on_finalize():
	$timer.stop()

func _on_timer_timeout():
	
	# let's not make this random
	if !last_state || last_state == "tumors":
		fsm.switch_state("laser")
		last_state = "laser"
	elif last_state == "laser":
		fsm.switch_state("shooting")
		last_state = "shooting"
	else:
		fsm.switch_state("tumors")
		last_state = "tumors"
		
	
#	if randf() > 0.5:
#		fsm.switch_state("laser")
#	else:
#		fsm.switch_state("tumors") # TODO switch randomly to either laser, tumors, or ???
