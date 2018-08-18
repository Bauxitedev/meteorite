extends Node


func play_sound_at(name, pos, pitch=1.0, unit_db=null):
	var dupl = get_node(name).duplicate()
	LevelManager.add_child(dupl)
	dupl.play()
	dupl.global_transform.origin = pos
	dupl.pitch_scale = pitch
	
	if unit_db:
		dupl.unit_db = unit_db
	
	dupl.connect("finished", dupl, "queue_free")

func play_sound(name, pitch=1.0): # no spatial
	var dupl = get_node(name).duplicate()
	add_child(dupl)
	dupl.play()
	dupl.pitch_scale = pitch
	dupl.connect("finished", dupl, "queue_free")