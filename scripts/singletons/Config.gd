extends Node

var sfx_volume
var music_volume
var mouse_sensitivity
var fullscreen

func _ready():
	# TODO load all of this from config
	set_sfx_volume(0.5)
	set_music_volume(0.5)
	set_mouse_sensitivity(0.02)
	set_fullscreen(true) 
	
func linear_to_db(vol):
	#var vol_db = -80
	#if vol > 0:
#		vol_db = 10.0 * (log(vol) / log(10.0))
	#return vol_db
	
	return pow(vol, 0.1) * 80 - 80
	
func set_sfx_volume(vol):
	sfx_volume = vol
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), linear_to_db(vol))

func set_music_volume(vol):
	music_volume = vol
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(vol))
	
func set_mouse_sensitivity(value):
	mouse_sensitivity = value
	
func set_fullscreen(value):
	fullscreen = value
	OS.window_fullscreen = value