extends Spatial

var is_open = false
var is_locked = false

export (String) var door_list # string containing door half names separated by commas
export (String) var door_texture_prefix = "textures/doors/door"
var doors = []

var initial_positions = {} 
var target_positions = {}


onready var tween = $tween
onready var timer = $timer

export var duration = 1.4

var BulletColor = Enums.BulletColor
# https://github.com/godotengine/godot/issues/19704 too bad!
export(int, "Blue", "Green", "Red") var bullet_color = 0

func _ready():
	
	var door_list_split = door_list.split(",")
	for door_name in door_list_split:
		doors.push_back(get_node(door_name))
	
	match bullet_color:
		BulletColor.RED: set_doormat_tex(load("res://%s_red.png" % door_texture_prefix))
		BulletColor.GREEN: set_doormat_tex(load("res://%s_green.png" % door_texture_prefix))
		BulletColor.BLUE: set_doormat_tex(load("res://%s_blue.png" % door_texture_prefix))
		
	for door in doors:
		var door_name = door.name
		initial_positions[door_name] = door.translation
		target_positions[door_name] = door.get_node("col").move_to_pos
		
	
func set_doormat_tex(tex):
	for door in doors:
		var mat = door.get_surface_material(0)
		mat.albedo_texture = tex
	
func open_if_match(col):
	if bullet_color == col:
		print("match")
		open()
		

func open():
	
	if is_open || is_locked: return
	
	Sound.play_sound_at("door_open", global_transform.origin)
	
	is_open = true
	
	for door in doors:
		var door_name = door.name
		tween.interpolate_property(door, "translation", initial_positions[door_name], target_positions[door_name], duration, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	tween.start()
	
	timer.start()
	yield(timer,"timeout")
	close()
	
	
func close():
	 
	if !is_open: return
	
	Sound.play_sound_at("door_open", global_transform.origin)	
	
	is_open = false
	
	for door in doors:
		var door_name = door.name
		tween.interpolate_property(door, "translation", target_positions[door_name], initial_positions[door_name], duration, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	tween.start()
	
	timer.stop()

func _on_boss_wake_up_trigger_body_entered(body):
	if body.is_in_group("player") && !body.boss_defeated:
		close()
		lock()
		
func lock():
	is_locked = true
	
		
func unlock():
	print("door unlocked")
	is_locked = false