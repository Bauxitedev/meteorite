extends "res://scripts/fsm/fsm_state.gd"

func on_init():
	$timer.start()
	yield($timer, "timeout")
	on_next()
	
func on_finalize():
	$timer.stop() #!!!
	
func on_next():
	fsm_owner.current_text += 1
	
	Sound.play_sound("ui_select", 0.5)
	
	if fsm_owner.current_text >= fsm_owner.texts.size():
		fsm.switch_state("disappearing")
	else:
		fsm.switch_state("writing")