extends "res://scripts/guns/states/gun_state.gd"

onready var gun = fsm_owner.get_node("Guns")
onready var timer = $timer

func on_init():
	gun.hide()
	fsm_owner.crosshair.hide()
	
func on_finalize():
	timer.start()
	fsm_owner.crosshair.show()

func _on_timer_timeout():
	gun.show()
	Sound.play_sound("weapon_switch")
	#gun.call_deferred("show") # needed otherwise you can see the gun on the unlock screen
