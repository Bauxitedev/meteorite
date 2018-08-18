extends StaticBody

export (NodePath) var parent_door
export (Vector3) var move_to_pos

func shoot_open(color):
	get_node(parent_door).open_if_match(color)