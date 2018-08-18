extends "res://scripts/fsm/fsm_state.gd"

func on_think():
	
	var raycast = fsm_owner.raycast
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		
		if coll.is_in_group("player"):
			fsm.switch_state("alerted")
			Sound.play_sound_at("turret_alert", fsm_owner.global_transform.origin)