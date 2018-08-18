extends "res://scripts/fsm/fsm_state.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func on_init():
	$timer_end.start()
	$timer_shoot.start()
	
	yield($timer_end, "timeout")
	
	fsm.switch_state("idle")
	
func on_finalize():
	$timer_end.stop()
	$timer_shoot.stop()



func _on_timer_shoot_timeout():
	
	Sound.play_sound_at("shoot_blue", fsm_owner.global_transform.origin, 1.0, 10.0)
	var bullet = preload("res://scenes/guns/bullet.tscn").instance()
	
	LevelManager.get_current_level().add_child(bullet)
	bullet.init(fsm_owner.to_global(Vector3(0,0,-4)), -fsm_owner.global_transform.basis.z.normalized(), Enums.BulletColor.RED, true)
	