extends "res://scripts/fsm/fsm_state.gd"

var label
var progress

func on_init():
	
	label = fsm_owner.label # can't use onready here
	
	label.text = fsm_owner.texts[fsm_owner.current_text]
	label.percent_visible = 0
	progress = 0
	
func update(delta):
	progress += delta * 10
	label.visible_characters = progress
	
	if label.percent_visible > 1:
		fsm.switch_state("written")
		
func on_next():
	label.percent_visible = 1
	fsm.switch_state_immediately("written")