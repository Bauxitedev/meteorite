extends "res://scripts/fsm/fsm_state.gd"

var can_boost
var previous_velocity = Vector3(0,0,0)
var can_play_footstep_land = true

var footstep_offset_mult = 1

func on_init():
	can_boost = false # prevent boosting multiple times in the air

	
func fixed_update(delta):
	fsm_owner.process_walk(delta)
	update_footstep_timer()
	check_play_land_footstep()	
	fsm_owner.process_gravity(delta)
	
	if fsm_owner.is_on_floor():
		can_boost = true
	
	
func check_play_land_footstep():
	if previous_velocity.y < -0.5 && abs(fsm_owner.velocity.y) < 0.1 && can_play_footstep_land:
		
		
		Sound.play_sound_at("footstep", fsm_owner.global_transform.origin, 1.0, 6.0)
		$footstep_timer.stop()
		$footstep_timer.start()
		
		can_play_footstep_land = false
		$footstep_land_timer.start()
		yield($footstep_land_timer, "timeout")
		can_play_footstep_land = true
		
	previous_velocity = fsm_owner.velocity

		
#func update(delta):
#	update_footstep_timer()
	
func update_footstep_timer():
	$footstep_timer.wait_time = clamp(2.0 / (fsm_owner.get_horizontal_velocity().length() + 1), 0.1, 0.6)
	#print($footstep_timer.wait_time )
	
func handle_input(event):
	fsm_owner.process_look(event)
	fsm_owner.process_jump(event)
	fsm_owner.process_shoot(event)
	
	if fsm_owner.is_unlocked(Enums.UPGRADE_BOOST) && event.is_action_pressed("boost") && can_boost:
		fsm.switch_state("boost")
		
func _on_footstep_timer_timeout():
	
	if fsm_owner.is_on_floor():
		var hor_vel_len = fsm_owner.get_horizontal_velocity().length()
		
		if hor_vel_len > 0.01:
			# TODO something is going wrong here??? or the is_on_floor check fails
			var offset = (fsm_owner.get_look_vector() * Vector3(1,0,1)).normalized().cross(Vector3(0,1,0)) * 0.05 * footstep_offset_mult
			footstep_offset_mult *= -1
		
			Sound.play_sound_at("footstep", fsm_owner.global_transform.origin + offset, 1.0, clamp(hor_vel_len, 0.0, 10.0) - 5.0)
