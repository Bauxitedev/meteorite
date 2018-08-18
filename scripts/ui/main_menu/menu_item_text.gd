extends Node2D

var config_property_name
var is_option = false
var option_type

func set_text(text):
	$label.text = text

func show_slider(slider_min, slider_max, slider_step, config_prop_name):
	$slider.show()
	is_option = true
	
	$slider.min_value = slider_min
	$slider.max_value = slider_max
	$slider.step = slider_step	
	config_property_name = config_prop_name
	
	$slider.value = Config.get(config_property_name)
	print("%s = %s" % [config_property_name, $slider.value])
	
	option_type = Enums.MenuItemType.OptionSlider
	
func show_checkbox(config_prop_name):
	$checkbox.show()
	is_option = true
	config_property_name = config_prop_name
	
	$checkbox.pressed = Config.get(config_property_name)
	option_type = Enums.MenuItemType.OptionCheckbox
	
	
func set_slider_opacity(opacity):
	$slider.modulate.a = opacity
	
func adjust(value):
	$slider.value += $slider.step * value
	
	Sound.play_sound("player_hit",4)
	Config.call("set_%s" % config_property_name, $slider.value)
	
func toggle():
	$checkbox.pressed = !$checkbox.pressed 
	Config.call("set_%s" % config_property_name, $checkbox.pressed)