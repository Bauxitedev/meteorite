extends Node

var effects = {}

func _ready():
	
	for c in get_children():
		
		remove_child(c) # IMPORTANT - do NOT queue_free, we want to keep it in memory
		effects[c.name] = c
		
func spawn_effect(name, position):
	var spawned = effects[name].duplicate()
	LevelManager.add_child(spawned)
	spawned.global_transform.origin = position
	
	return spawned