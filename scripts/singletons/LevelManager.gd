extends Node

onready var node_main = get_node("/root/main")

func reload_level():
	node_main.game_state.switch_state("game")

func get_current_level():
	return node_main.current_level
	
func switch_to(state):
	randomize() #!
	node_main.game_state.switch_state(state)