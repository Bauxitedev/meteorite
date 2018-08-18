extends "res://scripts/fsm/fsm_state.gd"

func fixed_update(delta):
	fsm_owner.process_gravity(delta)
	
	var mult = 0.9
	fsm_owner.velocity *= Vector3(mult, 1.0, mult)
	
func on_init():
	
	# limp to the side
	var rot_start = Quat(fsm_owner.global_transform.basis)
	
	var axis = (fsm_owner.cam.global_transform.basis.z * Vector3(1,0,1)).normalized()
	var rot_end = rot_start * Quat(axis, PI/-2)
	
	$tween.interpolate_method(self, "tween_rot", rot_start, rot_end, 1.6, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$tween.start()
	
	var shape_node = fsm_owner.get_node("shape")
	var shape = shape_node.shape.duplicate() # important
	shape.radius /= 2
	shape_node.shape = shape
	
	var timer = $timer
	timer.start()
	yield(timer, "timeout")
	
	#LevelManager.switch_to("main_menu")
	LevelManager.reload_level()
	
func tween_rot(quat):
	fsm_owner.global_transform.basis = Basis(quat)