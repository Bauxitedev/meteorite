extends Spatial

var scene_to_spawn 

func init(scene_to_spawn):
	print("respawner active")
	self.scene_to_spawn = scene_to_spawn

func _on_timer_spawn_timeout():
	
	# try spawning if distance to player is close enough
	
	if (!try_spawn()):
		$timer_retry.start()
	
# returns true if spawned
func try_spawn():
	
	var ply = PlayerData.get_player()
	var dist2 = ply.global_transform.origin.distance_squared_to(global_transform.origin)
	var max_dist2 = pow(19, 2)
	
	if dist2 < max_dist2:
		return false # too close
	
	var child = load(scene_to_spawn).instance()
	LevelManager.get_current_level().add_child(child)
	child.global_transform = global_transform
	print("respawned")	
	queue_free()
	
	return true


func _on_timer_retry_timeout():
		
	# try spawning if distance to player is close enough
	
	if (try_spawn()):
		$timer_retry.stop()
