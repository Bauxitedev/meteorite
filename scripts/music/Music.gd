extends Node


onready var music_state = $music_state

var fading_to = null
var fading_from = null

var music_queue = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	music_state.switch_state_immediately("stopped")
	
func _process(delta):
	music_state.update(delta)

func get_player(name):
	return $songs.get_node(name)
	
func play(name):
#	print("play %s" % name)
	music_state.state.play(name)
	
func enqueue(name):
	music_queue.push_front(name)
#	print("enqueued %s" % name)
	
func is_queue_empty():
	return music_queue.empty()
	
func pop_queue():
	
	if music_queue.empty():
		print("no more music left")
		return
		
	var next = music_queue.back()
	music_queue.pop_back()
	
	if fading_to == next:
		print("not fading from %s to %s" % [fading_to, next])
		pop_queue()
		return
	
	fading_from = fading_to	
	fading_to = next
	
	music_state.switch_state("crossfading")