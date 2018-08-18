extends Node2D

var can_skip_intro = false
var can_skip_intro_out = false


func intro_done():
	can_skip_intro = true
	
	$timer_intro.start()
	
	yield($timer_intro, "timeout")
	
	start_intro_out()
	
func start_intro_out():
	$animation.play("intro_out")
	Music.play("menu")
	
func intro_out_done():
	can_skip_intro_out = true
	
func intro_leave_done():
	LevelManager.switch_to("main_menu")
	
func _unhandled_input(event):
	
	if  event.is_action_pressed("ui_accept"):
		
		if can_skip_intro:
			
			$timer_intro.stop()
			can_skip_intro = false
			start_intro_out()
		
		if can_skip_intro_out:
			
			can_skip_intro_out = false
			$animation.play("intro_leave")
			