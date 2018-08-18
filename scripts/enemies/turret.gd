extends StaticBody

onready var ai_state = $ai_state
onready var raycast = $raycast

var health = 10

func hurt(amount, color):
	health -= amount
	if health <= 0:
		destroy()

func destroy():
	
	if is_queued_for_deletion():
		return
		
	queue_free()
	
	FX.spawn_effect("turret_explosion", global_transform.origin).init()
	
	# add respawner
	var child = preload("res://scenes/enemies/respawner.tscn").instance()
	child.init("res://scenes/enemies/turret.tscn")
	LevelManager.get_current_level().add_child(child)
	child.global_transform = global_transform

func _ready():
	ai_state.switch_state_immediately("asleep")
	
	$ai_timer.wait_time += rand_range(-1,1)*0.01
	
func aim_at(pos):
	
	var look_at_vec = pos - global_transform.origin
	var look_at_vec_2d = Vector2(look_at_vec.x, look_at_vec.z)
	
	# https://stackoverflow.com/a/2782712
	var pitch = PI/2+atan(sqrt(pow(look_at_vec.x, 2) + pow(look_at_vec.z,2))/look_at_vec.y)
	var roll = 0#sin(OS.get_ticks_msec()/100.0) # this is damn funny 
	var yaw = -look_at_vec_2d.angle()+PI/2
	
	if pitch > PI/2:
		pitch -= PI
	
	
	$rotation_yaw.global_transform.basis = Basis(Vector3(0,yaw,roll)) 
	$rotation_yaw/rotation_pitch.transform.basis = Basis(Vector3(pitch,0,0)) 

func _process(delta):


	var ply_pos = PlayerData.get_player().global_transform.origin
	raycast.look_at(ply_pos, Vector3(0,1,0)) # NOTE! -Z points towards the player, not +Z!
	
	ai_state.update(delta)


func _on_ai_timer_timeout():
	ai_state.state.on_think()
