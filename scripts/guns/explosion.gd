extends Area

var fired_by_enemy
var seen_nodes = [] 

func _ready():
	pass

func init(pos, fired_by_enemy):
	global_transform.origin = pos
	self.fired_by_enemy = fired_by_enemy
	Sound.play_sound_at("red_explode", global_transform.origin)

func _physics_process(delta):
	
	var bodies = get_overlapping_bodies()
	for body in bodies:
		
		var is_enemy = body.is_in_group("enemy")
		var is_door_half = body.is_in_group("door_half")
		if !(body in seen_nodes):
			
			if is_enemy:
				body.hurt(17, Enums.BulletColor.RED)
				seen_nodes.push_back(body)
				
			# TOO BAD!! areas can't detect mesh collision shapes!
			#elif is_door_half:
			#	print("explosion opened door")
			#	body.shoot_open(Enums.BulletColor.RED)
			#	seen_nodes.push_back(body)

func _on_timer_timeout():
	queue_free()
