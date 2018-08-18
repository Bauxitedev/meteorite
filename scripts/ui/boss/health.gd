extends Node2D

onready var bar_fg = $bar.get_stylebox("fg")
onready var initial_bar_fg_color = bar_fg.bg_color

var hp_smooth = 0

func _ready():
	pass

func _process(delta):
	
	var boss = get_parent().get_parent() # TODO don't do this
	var hp = boss.health
	var max_hp = boss.max_health
	
	$bar.max_value = max_hp
	
	hp_smooth += (hp - hp_smooth) * clamp(delta * 10, 0, 1)
	$bar.value = ceil(hp_smooth)
	$bar.update() # IMPORTANT
	
func flash_color(col):
	$tween.interpolate_property(bar_fg, "bg_color", col, initial_bar_fg_color, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$tween.start()
	
func hurt():
	flash_color(Color(0,1,0))
	
func heal():
	flash_color(Color(1,0,0))