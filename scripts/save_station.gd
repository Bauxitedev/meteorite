extends Area

signal saved(save_station)

onready var diskette = $diskette
onready var timer = $timer
var can_save = false

func _ready():
	wait_for_save()
	
func wait_for_save():
	can_save = false
	timer.start()
	yield(timer,"timeout")
	can_save = true
	

func _process(delta):
	diskette.rotate_y(delta)


func _on_save_station_body_entered(body):
	if body.is_in_group("player"):
		
		if can_save:
			
			Dialogs.add_text_dialog(["Game saved.", "Health replenished."])
			body.heal_max()
			Sound.play_sound("save")
			
			emit_signal("saved", self)
			
			print("saved")
			Saver.do_save()
			wait_for_save()
		
