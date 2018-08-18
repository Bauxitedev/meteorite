extends Node2D

onready var menu_state = $menu_state
var selected_item = 0

var in_option_state = false
var pause_menu = false

func _ready():
	
	if get_parent().name == "pause":
		set_pause_menu()
	
	menu_state.switch_state_immediately("main")
	

	
func set_pause_menu():
	pause_menu = true

func _process(delta):
	menu_state.update(delta)
	
	var item = $menu_item_texts.get_child(selected_item)
	$cam.position = item.position
	
	item.set_slider_opacity(1 if in_option_state else 0.3)
	
	var max_item = $menu_item_texts.get_child_count()-1
	$layer/hbox/left.modulate.a = 255 if selected_item > 0 || in_option_state else 0
	$layer/hbox/right.modulate.a = 255 if selected_item < max_item || in_option_state else 0
	
	var r = 0 if in_option_state else 255
	
	$layer/hbox/left.modulate.r = r
	$layer/hbox/right.modulate.r = r	
	
	if pause_menu:
		# massive hack for parallax bug
		
		var target_pos =  -$cam.position + Vector2(32,32)
		var curr_pos = get_parent().position
		get_parent().position += (target_pos - curr_pos) * clamp(delta*10.0, 0.0, 1.0)
	
func _unhandled_input(event):
	
	if !in_option_state:
		if event.is_action_pressed("ui_left"):
			selected_item -= 1
			Sound.play_sound("ui_select")
		if event.is_action_pressed("ui_right"):
			selected_item += 1
			Sound.play_sound("ui_select")			
			
		var max_item = $menu_item_texts.get_child_count()-1
		selected_item = clamp(selected_item, 0, max_item)
		
		if event.is_action_pressed("ui_cancel"):
			
			if menu_state.state.name != "main":
				menu_state.switch_state("main")
				Sound.play_sound("ui_select", 0.5)
			elif pause_menu:
				Dialogs.remove_dialog(get_parent())
				Sound.play_sound("ui_select", 0.5)
			
	else:
		
		var item =  $menu_item_texts.get_child(selected_item)
		
		var repeat = event.is_echo() || event.is_pressed()
		
		if event.is_action("ui_left") && repeat:
			item.adjust(-1)		
		if event.is_action("ui_right") && repeat:
			item.adjust(1)
		
	if event.is_action_pressed("ui_accept"):
		
		Sound.play_sound("ui_select", 0.5)
		
		var item =  $menu_item_texts.get_child(selected_item)
		
		if item.is_option:
			
			if item.option_type == Enums.MenuItemType.OptionSlider:
				in_option_state = !in_option_state
				return
			if 	item.option_type == Enums.MenuItemType.OptionCheckbox:
				item.toggle()
				return
			
		var item_name = item.name
		
		if !pause_menu:
			match item_name:
				
				"play": menu_state.switch_state("play")
				"options":	menu_state.switch_state("options")
				"quit": get_tree().quit()
				
				"new_game": 
					Saver.delete_save_file() # TODO ask for confirmation maybe?
					LevelManager.switch_to("game")
				"continue": LevelManager.switch_to("game")
		else:
			match item_name:
				
				"continue": Dialogs.remove_dialog(get_parent())				
				"options":	menu_state.switch_state("options")
				"quit":
					Dialogs.remove_dialog(get_parent()) # important becauswe pause
					LevelManager.switch_to("main_menu") #get_tree().quit() # TODO switch to main menu?

		