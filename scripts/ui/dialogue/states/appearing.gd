extends "res://scripts/fsm/fsm_state.gd"

func on_init():
	
	fsm_owner.label.text = ""
	$tween.interpolate_property(fsm_owner, "fade_amount", 0, 1, 0.5, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$tween.start()
	
	Sound.play_sound("ui_select", 2.0)
	
func on_finalize():
	$tween.stop_all()

func _on_tween_tween_completed(object, key):
	fsm.switch_state("writing")

func on_next():
	pass