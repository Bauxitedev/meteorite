extends "res://scripts/fsm/fsm_state.gd"

func on_init():
	print("boss death")
	fsm_owner.get_node("animation").play("dying")
	
	Sound.play_sound_at("boss_dying", fsm_owner.global_transform.origin)
	
	$timer.start()

func _on_timer_timeout():
	fsm_owner.queue_free()
	
	FX.spawn_effect("boss_explosion", fsm_owner.global_transform.origin).init()
	
	Music.play("silence")