extends StaticBody

var color
var boss

var is_disappearing = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func init(boss, color, pos):
	
	self.boss = boss
	self.color = color
	global_transform.origin = pos
	
	var mat = $mesh.get_surface_material(0)
	
	var col = Enums.get_bullet_color(color)
	var bright = 2.2
	col.r *= bright
	col.g *= bright
	col.b *= bright
	mat.albedo_color = col # this makes it easier to see what color it is
	
func hurt(amount, bullet_color):
	
	
	if bullet_color == color:
		boss.hurt(amount, bullet_color)
		destroy()
		
func destroy():
	
	if !is_disappearing:
		
		is_disappearing = true
		
		$animation.play("disappear")
		

		
		

func _on_animation_animation_finished(anim_name):
	if anim_name == "disappear":
		queue_free()
