extends "res://scripts/fsm/fsm_state.gd"

var tumors = []

onready var timer_spawn = $timer_spawn
onready var timer_end = $timer_end


func on_init():
	
	fsm_owner.get_node("animation").play("tumor_start")
	timer_spawn.start()
	timer_end.start()
	
	Sound.play_sound_at("boss_tumor_start", fsm_owner.global_transform.origin)
	
	for i in 13:
		
		yield(timer_spawn, "timeout")
		
		var tumor = preload("res://scenes/boss/tumor.tscn").instance()
		LevelManager.get_current_level().add_child(tumor)
		
		var col = randi() % 3
		
		var random_offset = Vector3(rand_range(-1,1), rand_range(-1,1), rand_range(-1,1)).normalized() * 4
		var pos = fsm_owner.global_transform.origin + random_offset
		tumor.init(fsm_owner, col, pos)
		
		tumors.push_back(weakref(tumor))

func on_finalize():
	for tumor in tumors:
		if tumor.get_ref():
			tumor.get_ref().destroy()
	timer_spawn.stop()
	timer_end.stop()
	fsm_owner.get_node("animation").play("tumor_end")
	
	Sound.play_sound_at("boss_tumor_end", fsm_owner.global_transform.origin)
	

func _on_timer_end_timeout():
	fsm.switch_state("idle")
