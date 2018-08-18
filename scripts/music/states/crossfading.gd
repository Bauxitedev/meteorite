extends "res://scripts/fsm/fsm_state.gd"


func on_init():
	
	print("fading from %s to %s" % [fsm_owner.fading_from, fsm_owner.fading_to])
	
	var tween = fsm_owner.get_node("tween")
	var min_db = -80
	var duration = 5.0
	
	var player_fading_from 
	
	if fsm_owner.fading_from:
		player_fading_from = fsm_owner.get_player(fsm_owner.fading_from)
		tween.interpolate_property(player_fading_from, "volume_db", 0, min_db, duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
		
	var player_fading_to = fsm_owner.get_player(fsm_owner.fading_to)	
	tween.interpolate_property(player_fading_to, "volume_db", min_db, 0, duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)	
	
	tween.start()
	
	player_fading_to.play()
	
	yield(tween, "tween_completed")
	
	if fsm_owner.fading_from:
		player_fading_from.stop()
	
	fsm.switch_state("playing")
	
	
func on_finalize():
	pass
	

func play(name):
	fsm_owner.enqueue(name)
	#fsm_owner.pop_queue() DON'T - wait until you enter the playing state