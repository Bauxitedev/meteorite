extends Node

const save_filename = "user://savegame.save"

func _ready():
	pass

func do_save():
	
	var save_game = File.new()
	save_game.open(save_filename, File.WRITE)
	# use store_line to save other shit
	
	var save_data = PlayerData.get_player().do_save()
	
	save_game.store_string(to_json(save_data))
	save_game.close()
	
	
func do_load():
	
	var save_game = File.new()
	if not save_game.file_exists(save_filename):
		print("no savefile detected")
		return # Error! We don't have a save to load.
		
	print("loading...")

	save_game.open(save_filename, File.READ)
	var save_data = parse_json(save_game.get_as_text())
	save_game.close()
	
	PlayerData.get_player().do_load(save_data)
	
func delete_save_file():
	
	var save_game = File.new()
	if save_file_exists():
		var dir = Directory.new()
		dir.remove(save_filename)
		print("save removed")
		
func save_file_exists():
	var save_game = File.new()
	return save_game.file_exists(save_filename)