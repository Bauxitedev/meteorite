extends KinematicBody

var BulletColor = Enums.BulletColor

# these need to be stored
const max_goal_speed = 5
const max_health = 100
var health = max_health
var upgrades = [] # list of strings

onready var cam = $cam
onready var tween = $tween
onready var gun_container = $cam/gun_container
onready var gun = gun_container.get_node("gun")
onready var body_state = $body_state


var velocity = Vector3(0,0,0)
var pitch = 0
var yaw = PI/2
var gun_rot = Quat()
var jump_counter = 1
var in_warning_state = false
var boss_defeated = false
var can_play_hit_sound = true

func _ready():
	tween.interpolate_property(cam, "fov", 0.1, cam.fov, 1.0,Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	
	body_state.switch_state_immediately("rest")
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	$ui/loading.hide()	
	
func _process(delta):
	
	cam.rotation = Vector3(pitch, yaw, 0)
	gun_rot = gun_rot.slerp(Quat(cam.global_transform.basis), 0.3)
	gun_container.global_transform.basis = Basis(gun_rot)
	
	body_state.update(delta)
	
	
func _unhandled_input(event): # it's very important to use UNHANDLED INPUT so things on top can steal mouse input
	body_state.handle_input(event)
	
	# TODO REMOVE
#	if event is InputEventKey and event.scancode == KEY_K:
#		hurt(100, BulletColor.RED)
		
	if event.is_action_pressed("ui_cancel"):
		Dialogs.add_pause_dialog()
	
func process_look(event):
	if event is InputEventMouseMotion:
		
		pitch -= event.relative.y * Config.mouse_sensitivity
		yaw -= event.relative.x * Config.mouse_sensitivity
		
		var eps = 1e-6
		pitch = clamp(pitch, -PI/2 + eps, PI/2 - eps)
		
		
func allowed_to_jump():
	var allowed_to_jump 
	match is_unlocked("TRIPLE_JUMP"):
		true:  allowed_to_jump = jump_counter <= 2
		false: allowed_to_jump = jump_counter == 0
	return allowed_to_jump
	
func process_jump(event):
	
	if event.is_action_pressed("ui_select") && allowed_to_jump() && velocity.y > -3.5: # && is_on_floor():
		velocity.y = 7
		jump_counter += 1
		Sound.play_sound("player_jump", 1 + (jump_counter - 1) * 0.1)
		
func process_shoot(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			gun.shoot()
		# TODO temp testing for now...
	if event is InputEventKey and event.pressed:
		match event.scancode:
			 KEY_1: if is_unlocked(Enums.UPGRADE_GUN_BLUE): gun.switch_to_color(BulletColor.BLUE)
			 KEY_2: if is_unlocked(Enums.UPGRADE_GUN_GREEN): gun.switch_to_color(BulletColor.GREEN)
			 KEY_3: if is_unlocked(Enums.UPGRADE_GUN_RED): gun.switch_to_color(BulletColor.RED)

func _physics_process(delta):
	body_state.fixed_update(delta)
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if body_state.state.has_method("process_boost"):
		body_state.state.process_boost(delta)
	
	if is_on_floor():
		jump_counter = 0
		
	gun.velocity = velocity
	gun.should_walk_jiggle = body_state.state.name == "rest" && is_on_floor()
		
	var slide_count = get_slide_count()
	for i in slide_count:
		var coll = get_slide_collision(i)
		if coll.collider.is_in_group("boss"):
			hurt(10, BulletColor.RED)
			velocity = (global_transform.origin - coll.collider.global_transform.origin).normalized() * 30
	
func process_walk(delta):
	
	var old_y = velocity.y
	
	var goal_vel = Vector3(0,0,0)

	
	if Input.is_action_pressed("ui_up"):
		goal_vel += (-cam.global_transform.basis.z * Vector3(1,0,1)).normalized()
	if Input.is_action_pressed("ui_down"):
		goal_vel += (cam.global_transform.basis.z * Vector3(1,0,1)).normalized()
	if Input.is_action_pressed("ui_left"):
		goal_vel += (-cam.global_transform.basis.x * Vector3(1,0,1)).normalized()
	if Input.is_action_pressed("ui_right"):
		goal_vel += (cam.global_transform.basis.x * Vector3(1,0,1)).normalized()
		
	if (goal_vel.length() > 1e-7): # don't divide by zero
		goal_vel = goal_vel.normalized()
		
	velocity = velocity.linear_interpolate(goal_vel * max_goal_speed, 0.1)
	velocity.y = old_y
	
func process_gravity(delta):
	velocity -=  Vector3(0,9.81,0) * delta
	
func hurt(amount, color = Enums.BulletColor.RED):
	health -= amount
	
	$ui/health.hurt()
	
	if health <= 0:
		die()
	elif can_play_hit_sound:
		Sound.play_sound("player_hit")
		can_play_hit_sound = false
		
		$hit_sound_timer.start()
		yield($hit_sound_timer, "timeout")
		can_play_hit_sound = true
		
func heal(amount):
	
	$ui/health.heal()
	health += amount
	
	if health >= max_health:
		health = max_health
		
func heal_max():
	heal(999999)
		
func die():
	if body_state.state.name != "dead":
		body_state.switch_state_immediately("dead")
		gun.die()
		Sound.play_sound("player_die")
	

	
func do_save():
	return {
		"health": health,
		"position": var2str(global_transform.origin),
		"pitch": pitch,
		"yaw": yaw,
		"upgrades": upgrades,
		"gun_color": var2str(gun.current_color),
		"in_warning_state": in_warning_state,
		"boss_defeated": boss_defeated
	}
	
func do_load(save_data):
	print("we got upgrades:", save_data["upgrades"])
	health = save_data["health"]
	global_transform.origin = str2var(save_data["position"])
	pitch = save_data["pitch"]
	yaw = save_data["yaw"]
	in_warning_state = save_data["in_warning_state"]
	
	set_boss_defeated(save_data["boss_defeated"])
	print("boss defeated? ", boss_defeated)
	
	upgrades = save_data["upgrades"] 
	gun.current_color = str2var(save_data["gun_color"])
	
	if has_any_gun_upgrade():
		gun.gun_state.switch_state("unholstering")
		
func set_boss_defeated(defeated):
	boss_defeated = defeated
	
	if defeated:
		print("boss deleted")
		
		var bosses = get_tree().get_nodes_in_group("boss")
		if !bosses.empty():
			bosses[0].queue_free()
			
		$escape_warning_timer.start()
		
func get_look_vector():
	return -cam.global_transform.basis.z
	
func unlock(upgrade):
	upgrades.push_back(upgrade)
	
	match upgrade:
		Enums.UPGRADE_GUN_RED:
			gun.unlock(BulletColor.RED)
			start_showing_boss_warning()
		Enums.UPGRADE_GUN_BLUE:
			gun.unlock(BulletColor.BLUE)
		Enums.UPGRADE_GUN_GREEN:
			gun.unlock(BulletColor.GREEN)
		
	Dialogs.add_text_dialog(Enums.get_upgrade_texts(upgrade)) 
		
func is_unlocked(upgrade):
	return upgrade in upgrades
	
func has_any_gun_upgrade():
	for upgrade in upgrades:
		if upgrade.begins_with("GUN"):
			return true
	return false
	
func start_showing_boss_warning():
	in_warning_state = true
	
func stop_showing_boss_warning():
	in_warning_state = false
	print("stop_showing_boss_warning")
	

func _on_boss_warning_timer_timeout():
	if in_warning_state:
		Dialogs.add_text_dialog(["Enemy activity detected near facility entrance.", "It appears to be secured by a red door.", "Requesting immediate investigation."]) 
	else:
		print("not in warning state")

func _on_save_station_boss_saved(save_station):
	save_station.queue_free() 
	set_boss_defeated(true)
	
	
func start_ending_sequence():
	Dialogs.add_text_dialog(["Nuclear warhead detected.", "ETA: 1 minute.", "Leave facility immediately.", "Your ship will be waiting for you."]) 
	
	# delete all save stations
	for station in get_tree().get_nodes_in_group("save_station"):
		station.queue_free()
		
	$ui/countdown.start()
	
	# unlock the door(s?)
	for door in get_tree().get_nodes_in_group("boss_door"):
		door.unlock()

	# spawn ufo
	for ufo in get_tree().get_nodes_in_group("ufo"):
		ufo.replace_by_instance()
		
	Music.play("escape")

func _on_escape_warning_timer_timeout():
	start_ending_sequence()


func _on_countdown_timer_timeout():
	hurt(99999)
	Sound.play_sound("nuke_explode")
	$ui/flash.show()

func get_horizontal_velocity():
	return velocity * Vector3(1,0,1)



func _on_tutorial_timer_timeout():
	if !Saver.save_file_exists():
		Dialogs.add_text_dialog(["You have successfully arrived at Sector Meteorite.", "Enemy activity detected. Take care.", "Use WASD to walk, and SPACE to jump."])
