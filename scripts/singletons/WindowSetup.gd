extends Node

func _ready():
	
	OS.window_size = Vector2(1280,720)
	yield(get_tree(), "idle_frame")
	OS.center_window()

	

	#OS.window_fullscreen = true
	#Config does this now
