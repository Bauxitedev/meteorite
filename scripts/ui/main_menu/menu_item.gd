extends Node

export var item_name = "???"

export (int, "Standard", "Option Slider", "Option Checkbox") var item_type

export (float) var slider_min = 0.0
export (float) var slider_max = 1.0
export (float) var slider_step = 0.1
export (String) var config_property_name = "TODO"