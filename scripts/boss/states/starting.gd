extends "res://scripts/fsm/fsm_state.gd"

func on_init():
	fsm_owner.get_node("animation").play("spawn")
	Music.play("boss")
	
	Sound.play_sound_at("boss_spawn", fsm_owner.global_transform.origin)
	
	$timer.start()
	
	fsm_owner.ui_health.show()
	
func on_finalize():
	$timer.stop()



func _on_timer_timeout():
	fsm.switch_state("idle") 