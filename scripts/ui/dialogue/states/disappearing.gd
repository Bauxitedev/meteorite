extends "res://scripts/fsm/fsm_state.gd"

func on_init():
	$tween.interpolate_property(fsm_owner, "fade_amount", 1, 0, 0.5, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	#$tween.interpolate_property(fsm_owner.label, "modulate", fsm_owner.label.modulate, Color(1,1,1,0), 0.5, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$tween.start()
	
func on_finalize():
	$tween.stop_all()

func _on_tween_tween_completed(object, key):
	Dialogs.remove_dialog(fsm_owner)

func on_next():
	pass