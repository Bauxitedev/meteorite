extends Area

export var upgrade_name = ""

func _ready():
	var color = get_upgrade_color()
	var mat = $cube.get_surface_material(0)
	mat.albedo_color = color
	
	var base_mat = $base.get_surface_material(0)
	base_mat.set_shader_param("col", color)
	
	$cube/light.light_color = color
	
func get_upgrade_color():
	match upgrade_name:
		Enums.UPGRADE_BOOST: return Color(0.5, 0.5, 0.5)
		Enums.UPGRADE_TRIPLE_JUMP: return Color(0.7, 0.5, 0.7)
		Enums.UPGRADE_GUN_BLUE:  return Enums.get_bullet_color(Enums.BulletColor.BLUE)
		Enums.UPGRADE_GUN_GREEN: return Enums.get_bullet_color(Enums.BulletColor.GREEN)
		Enums.UPGRADE_GUN_RED:   return Enums.get_bullet_color(Enums.BulletColor.RED)

func _process(delta):
	$cube.rotate_y(delta*3)


func _on_pickup_body_entered(body):
	if body.is_in_group("player"):
		queue_free()
		print("upgrade acquired: ", upgrade_name)
		body.unlock(upgrade_name)
		
		Sound.play_sound("upgrade_acquire")