extends "res://scripts/fsm/fsm_state.gd"

var laser_mesh
var raycast

var is_shooting

func on_init():
	
	Sound.play_sound_at("boss_laser_warmup", fsm_owner.global_transform.origin)
	is_shooting = false #!!!
	$timer_start.start()
	
	fsm_owner.get_node("animation").play("laser_start")
	
	raycast = fsm_owner.raycast
	laser_mesh = fsm_owner.laser_mesh
	
func fixed_update(delta):
	
	if !is_shooting:
		return
		
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		
		var hitpoint = raycast.get_collision_point()
		var length = (hitpoint - raycast.global_transform.origin).length()
		
		laser_mesh.mesh.height = length
		laser_mesh.translation.z = -length / 2
		
		fsm_owner.laser_hit_effect.global_transform.origin = hitpoint
		
		if coll.is_in_group("player"):
			coll.hurt(20*delta)
			
			
	
func on_finalize():
	
	
	fsm_owner.get_node("animation").play("laser_end")
	fsm_owner.get_node("boss_laser_loop").stop()
	
	
	$timer_start.stop()
	$timer_end.stop()

func _on_timer_timeout():
	is_shooting = true
	
	fsm_owner.get_node("boss_laser_loop").play()
	Sound.play_sound_at("boss_laser_start", fsm_owner.global_transform.origin)

	$timer_end.start()

func _on_timer_end_timeout():
	
	is_shooting = false
	fsm.switch_state("idle")
	
	Sound.play_sound_at("boss_laser_start", fsm_owner.global_transform.origin)
	
