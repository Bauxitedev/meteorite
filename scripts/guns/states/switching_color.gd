extends "res://scripts/guns/states/gun_state.gd"


onready var player = fsm_owner.get_node("AnimationPlayer")

func on_init():
	player.play("switch_color") 
	Sound.play_sound("weapon_switch")
	
func on_switch_finish():
	fsm.switch_state("unholstered")