extends "res://scripts/fsm/fsm_state.gd"

func on_init():
	
	var pos = Vector2(32,32)
	
	if fsm_owner.get_node("menu_item_texts").get_child_count() > 0:
		var prev_item = fsm_owner.get_node("menu_item_texts").get_child(fsm_owner.selected_item)
		if prev_item != null:
			pos = prev_item.position + (Vector2(0,-32) if name == "main" else Vector2(0,32)) # for added effect
	
	fsm_owner.selected_item = 0
	
	
	
	for c in get_children():
		
		var menu_item_text = preload("res://scenes/ui/main_menu/menu_item_text.tscn").instance()
		
		if fsm_owner.pause_menu && c.name == "play":
			menu_item_text.name = "continue"
			menu_item_text.set_text("Continue")
		else:
			menu_item_text.set_text(c.item_name)
			menu_item_text.name = c.name
			
		if !fsm_owner.pause_menu && c.name == "continue" && !Saver.save_file_exists():
			continue # don't show "continue" when no save game exists and not in pause menu
			
		fsm_owner.get_node("menu_item_texts").add_child(menu_item_text)
		menu_item_text.position = pos
		
		if c.item_type == Enums.MenuItemType.OptionSlider:
			menu_item_text.show_slider(c.slider_min, c.slider_max, c.slider_step, c.config_property_name)
		
		if c.item_type == Enums.MenuItemType.OptionCheckbox:
			menu_item_text.show_checkbox(c.config_property_name)
		
		
		
		pos += Vector2(64,0)
		
		
func on_finalize():
	
	for c in fsm_owner.get_node("menu_item_texts").get_children():
		c.name = var2str(randf()) # needed!
		c.queue_free()