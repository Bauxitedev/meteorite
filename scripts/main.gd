extends WorldEnvironment

onready var game_state = $game_state

var current_level = null

func _ready():
	game_state.switch_state_immediately("intro")
	
func _process(delta):
	game_state.update(delta)