extends "res://scripts/fsm/fsm_state.gd"

func on_init():
	$shoot_timer.start()
	
func on_finalize():
	$shoot_timer.stop()
	
func update(delta):
	var ply_pos = PlayerData.get_player().global_transform.origin
	fsm_owner.aim_at(ply_pos)

func on_think():
	
	var raycast = fsm_owner.raycast
	raycast.force_raycast_update()
	
	var player_visible = false
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		
		if coll.is_in_group("player"):
			player_visible = true
			

	if !player_visible:
		print("nap time")
		fsm.switch_state("asleep")


func _on_shoot_timer_timeout():
	
	Sound.play_sound_at("shoot_blue", fsm_owner.global_transform.origin)
	var bullet = preload("res://scenes/guns/bullet.tscn").instance()
	
	LevelManager.get_current_level().add_child(bullet)
	bullet.init(fsm_owner.global_transform.origin, -fsm_owner.raycast.global_transform.basis.z.normalized(), Enums.BulletColor.RED, true)
	
