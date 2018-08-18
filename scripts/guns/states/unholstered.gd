extends "res://scripts/guns/states/gun_state.gd"

var can_shoot = true

func on_shoot():
	
	if !can_shoot:
		return
	
	fsm_owner.get_node("AnimationPlayer").play("shoot")
	
	var origin = fsm_owner.global_transform.origin
	var forward = fsm_owner.global_transform.basis.z.normalized()
	
	match fsm_owner.current_color:
		Enums.BulletColor.BLUE: 
			spawn_bullet(origin, forward)
			Sound.play_sound_at("shoot_blue", fsm_owner.global_transform.origin)
		Enums.BulletColor.GREEN:
			for i in 4:
				spawn_bullet(origin, randomize_forward(forward, 0.08))
			wait_before_shoot(0.5)
			Sound.play_sound_at("shoot_green", fsm_owner.global_transform.origin)			
		Enums.BulletColor.RED: 
			spawn_bullet(origin, forward) # TODO spawn explosive things here
			wait_before_shoot(1)
			Sound.play_sound_at("shoot_red", fsm_owner.global_transform.origin)			
			
	
static func randomize_forward(forward, amount):
	var rand_vec = Vector3(rand_range(-1, 1), rand_range(-1, 1), rand_range(-1, 1)) * amount
	return (forward + rand_vec).normalized()
	
func wait_before_shoot(time):
	can_shoot = false
	$timer.wait_time = time
	$timer.start()
	yield($timer, "timeout")
	can_shoot = true
	
func spawn_bullet(origin, forward):
	var bullet = preload("res://scenes/guns/bullet.tscn").instance()
	LevelManager.get_current_level().add_child(bullet)
	bullet.init(origin, forward, fsm_owner.current_color)
	
	
func on_color_switch(color):
	fsm_owner.current_color = color
	fsm.switch_state("switching_color")