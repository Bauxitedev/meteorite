extends Node2D

onready var timer = $timer

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if !timer.is_stopped():
		
		var time_elapsed = timer.time_left
		
		var seconds = fmod(time_elapsed, 60)
		var millis = int(fmod(time_elapsed, 1) * 100)
		
		var text = "00:%02d.%02d" % [seconds, millis]
		$time.text = text

func start():
	timer.start()
	$time.show()