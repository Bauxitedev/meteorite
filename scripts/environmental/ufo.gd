extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var player_collect_area = $player_collect_area
onready var player_win_area = $player_win_area


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	$UFO.rotate_y(delta)

func _physics_process(delta):
	
	var bodies = player_collect_area.get_overlapping_bodies()
	
	for b in bodies:
		if b.is_in_group("player"):
			b.velocity = Vector3(0,3,0)
			
	bodies = player_win_area.get_overlapping_bodies()
	
	for b in bodies:
		if b.is_in_group("player"):
			Dialogs.add_text_dialog(["Mission completed.", "Enjoy your comfortable flight home."])
			LevelManager.switch_to("credits")
			Music.play("credits")