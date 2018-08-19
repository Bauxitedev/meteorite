extends StaticBody

var max_health = 200
var health = max_health

onready var boss_state = $boss_state
onready var raycast = $raycast

onready var ui_health = $ui/health
onready var laser = $laser
onready var laser_mesh = $laser/mesh
onready var laser_hit_effect = $laser/hit_effect


func _process(delta):

	boss_state.update(delta)
	
func _physics_process(delta):
	
	# NOTE this is always needed or the raycast won't be in the right direction
	var original_basis = global_transform.basis
	look_at(PlayerData.get_player().global_transform.origin, Vector3(0,1,0))
	var look_at_basis =  global_transform.basis
	global_transform.basis = Basis(Quat(original_basis).slerp(Quat(look_at_basis), 0.05))
	
	boss_state.fixed_update(delta)	

func _ready():
	boss_state.switch_state("inactive")

func hurt(amount, color):
	health -= amount
	ui_health.hurt()
	
	Sound.play_sound_at("boss_hit", global_transform.origin)
	
	if health <= 0 && boss_state.state.name != "dying":
		boss_state.switch_state("dying")


func _on_boss_wake_up_trigger_body_entered(body):
	# TODO although the signal is in oneshot mode, ensure you can't do this after saving after boss death
	if body.is_in_group("player"):
		boss_state.switch_state("starting")
		body.stop_showing_boss_warning()
