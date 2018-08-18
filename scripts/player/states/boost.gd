extends "res://scripts/fsm/fsm_state.gd"

func on_init():
	
	Sound.play_sound("boost")
	
	var timer = $timer
	timer.start()
	yield(timer, "timeout")
	fsm.switch_state("rest")
	
	
	
func on_finalize():
	$timer.stop() # IMPORTANT!
	Sound.play_sound("boost_stop")
	
	
func fixed_update(delta):
		
	fsm_owner.velocity.y *= 0.7
	var old_y = fsm_owner.velocity.y
	
	var player_vel_2d = (fsm_owner.velocity * Vector3(1,0,1))
	if player_vel_2d.length() < 0.9:
		player_vel_2d = fsm_owner.get_look_vector() * Vector3(1,0,1)
	
	fsm_owner.velocity = player_vel_2d.normalized() * fsm_owner.max_goal_speed * 1.8
	fsm_owner.velocity.y = old_y
	
func process_boost(delta):
		
	if fsm_owner.is_on_wall():
		
		fsm.switch_state("rest")
		return # IMPORTANT or you'll bounce from the wall if facing away from it




func handle_input(event):
	fsm_owner.process_look(event)
	fsm_owner.process_shoot(event)
	
	if event.is_action_pressed("boost"):
		fsm.switch_state("rest")