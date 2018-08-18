extends Spatial

var BulletColor = Enums.BulletColor
var current_color = BulletColor.BLUE
onready var gun_state = $gun_state
onready var crosshair = $ui/crosshair

var velocity = Vector3(0,0,0)
var accumulated_movement = 0
var should_walk_jiggle = false

onready var mat_glow = $Guns/Gun1.get_surface_material(1)

func _ready():
	gun_state.switch_state_immediately("holstered")
	
func unlock(color):
	
	current_color = color
	
	if gun_state.state.name == "holstered":
		gun_state.switch_state_immediately("unholstering") #first gun acquired (need immediately or you get visual glitch)
	else:
		gun_state.switch_state("switching_color")

func _process(delta):
	# fade to new color
	mat_glow.emission = mat_glow.emission.linear_interpolate(Enums.get_bullet_color(current_color), 0.1)
	mat_glow.emission_energy = 0.8+0.5*pow(0.5+0.5*sin(OS.get_ticks_msec() / 500.0),7)
	gun_state.update(delta)
	
func _physics_process(delta):
	
	# jiggle gun
	# (need to do it per-part, because Guns translation is being overridden by the animation player)
	
	var velocity_xz = velocity * Vector3(1,0,1)
	accumulated_movement += velocity_xz.length() * delta
	
	for g in $Guns.get_children():
		g.translation *= clamp(1 - delta * 10, 0.0, 1.0)
		g.translation -= g.global_transform.basis.xform_inv(velocity) * delta * 5
		
		# also add walk jiggle
		if should_walk_jiggle:
			g.translation -= clamp(velocity_xz.length(), 0.0, 1.0) * Vector3(0,1,0) * sin(accumulated_movement * 1.7) * delta * 2
	
func switch_to_color(color):
	
	if color == current_color:
		return
	
	gun_state.state.on_color_switch(color)
	
func switch_to_next_color():
	
	match current_color:
		BulletColor.BLUE: switch_to_color(BulletColor.GREEN)
		BulletColor.GREEN: switch_to_color(BulletColor.RED)
		BulletColor.RED: switch_to_color(BulletColor.BLUE)
		
	
func shoot():
	gun_state.state.on_shoot()
	
func die():
	$AnimationPlayer.play("unholster", -1, -4.0, true)