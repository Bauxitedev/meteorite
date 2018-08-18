extends "res://scripts/fsm/fsm_state.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func play(name):
	fsm_owner.fading_to = name
	fsm.switch_state("crossfading")