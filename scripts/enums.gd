tool
extends Node

# blue is 0, green is 1, red is 2
enum BulletColor {
	BLUE, GREEN, RED
}

enum MenuItemType {Standard, OptionSlider, OptionCheckbox}

# these can't be enums cuz they're strings (update, they CAN be, just define a 2nd dict with enum keys and string values)
const UPGRADE_GUN_BLUE = "GUN_BLUE"
const UPGRADE_GUN_GREEN = "GUN_GREEN"
const UPGRADE_GUN_RED = "GUN_RED"
const UPGRADE_BOOST = "BOOST"
const UPGRADE_TRIPLE_JUMP = "TRIPLE_JUMP"

static func get_bullet_color(color):
	match color:
		BulletColor.BLUE: return Color(0.1, 0.5, 0.8)
		BulletColor.GREEN: return Color(0.3, 0.8, 0.3)
		BulletColor.RED: return Color(0.9, 0.2, 0.2)
		_: print("ERROR - invalid color ", color)
		
static func get_upgrade_texts(upgrade):
	match upgrade:
		UPGRADE_GUN_BLUE: return ["Plasma Beam acquired.", "Click to shoot.", "Open doors by shooting them.", "This only works if its color matches."]
		UPGRADE_GUN_GREEN: return ["Cluster Beam acquired.", "Press 1/2 to switch weapons."] 
		UPGRADE_GUN_RED: return ["Neutron Beam acquired.", "Press 1/2/3 to switch weapons."] 
		UPGRADE_BOOST: return ["Air Boost acquired.", "Press X to boost forward.", "This also works in mid-air.", "Triple jump is still possible after a boost."]
		UPGRADE_TRIPLE_JUMP: return ["Triple Jump acquired.", "Press SPACE repeatedly in mid-air.", "This will not work while falling down."]
		