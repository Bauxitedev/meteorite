extends Node2D

onready var bar_fg = $bar.get_stylebox("fg")
onready var initial_bar_fg_color = bar_fg.bg_color
onready var initial_plus_color = $plus.modulate

var hp_smooth = 0

func _ready():
	pass

func _process(delta):
	
	var ply = PlayerData.get_player()
	var hp = ply.health
	var max_hp = ply.max_health
	
	hp_smooth += (hp - hp_smooth) * clamp(delta * 10, 0, 1)
	visible = hp_smooth < max_hp - 1e-2
	$bar.value = ceil(hp_smooth)
	$bar.update() # IMPORTANT
	
func flash_color(col):
	$tween.interpolate_property($plus, "modulate", col, initial_plus_color, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.interpolate_property(bar_fg, "bg_color", col, initial_bar_fg_color, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.start()
	
func hurt():
	flash_color(Color(1,0,0))
	
func heal():
	flash_color(Color(0,1,0))