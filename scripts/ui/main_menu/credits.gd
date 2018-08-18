extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
	$button.hide()

func _process(delta):
	
	if Input.is_action_pressed("ui_select"):
		$animation.playback_speed = 5
	else:
		$animation.playback_speed = 1

func done_scrolling():
	
	$button.show()
	$button.grab_focus()

func _on_button_button_down():
	LevelManager.switch_to("main_menu")


func _on_timer_timeout():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
