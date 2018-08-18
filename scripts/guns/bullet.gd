extends Spatial #can't use area https://github.com/godotengine/godot/issues/16392

var velocity = Vector3(0,0,0)
var BulletColor = Enums.BulletColor
var color
var fired_by_enemy = false
onready var raycast = $raycast

var can_play_ricochet_sound = true

func ricochet():
	var norm = raycast.get_collision_normal()
	velocity = velocity.bounce(norm.normalized()) 
	global_translate(norm*0.01)
	
	if can_play_ricochet_sound:
		Sound.play_sound_at("bullet_ricochet", global_transform.origin)
		can_play_ricochet_sound = false
		$timer_ricochet_sound.start()
		yield($timer_ricochet_sound, "timeout")
		can_play_ricochet_sound = true
	
	
func _physics_process(delta):
	
	raycast.cast_to = velocity * delta * 2
	
	global_translate(velocity * delta)
	#var coll = move_and_collide(velocity * delta)
	
	if raycast.is_colliding():
		
		var collider = raycast.get_collider()
		
		# IMPORTANT - collider can still be null here for some reason!
		
		if !collider:
			destroy()
		else:
			var hit_boss = collider.is_in_group("boss")
			var hit_enemy = collider.is_in_group("enemy")
			var hit_door = collider.is_in_group("door_half")
			var hit_player = collider.is_in_group("player")		
			
			var should_bounce = hit_boss || color == BulletColor.GREEN  # green bullets bounce

				
			if !fired_by_enemy: #if fired by player...
				if hit_door:  
					collider.shoot_open(color)			
					should_bounce = false # IMPORTANT
				elif hit_enemy:
					
					var hurt_amount = 3
					if color == BulletColor.RED:
						hurt_amount = 17
					collider.hurt(3, color)
					should_bounce = false # IMPORTANT
			else:
				if hit_player:
					collider.hurt(3, color)
					

			if should_bounce: 			
				ricochet()
				# TODO play a wah wah sound here
			else:
				destroy()
				
					
func destroy():
	
	if !is_queued_for_deletion():
		queue_free() # TODO show pretty particles
		
		if color == BulletColor.RED && !fired_by_enemy:
			var explosion = preload("res://scenes/guns/explosion.tscn").instance()
			LevelManager.get_current_level().add_child(explosion)
			explosion.init(global_transform.origin, fired_by_enemy)			

func init(position, direction, color, is_fired_by_enemy = false):
	fired_by_enemy = is_fired_by_enemy
	
	if is_fired_by_enemy:
		raycast.set_collision_mask_bit(1, true) #player
		raycast.set_collision_mask_bit(2, false) #enemy
		
	
	global_transform.origin = position
	velocity = direction * 10 
	
	self.color = color
	
	$glow.get_surface_material(0).albedo_color = Enums.get_bullet_color(color) * 3.0
	$light.light_color = Enums.get_bullet_color(color)



func _on_timer_timeout():
	destroy()
