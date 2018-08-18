extends "res://scripts/guns/states/gun_state.gd"

onready var player = fsm_owner.get_node("AnimationPlayer")

func on_init():
	player.play("unholster") 
	player.connect("animation_finished", self, "on_anim_finish", [], CONNECT_ONESHOT)
	
func on_anim_finish(anim):
	if anim == "unholster":
		fsm.switch_state("unholstered")