extends Area

# Added for making the game work with Godot 3.3.2
# This trigger is a cleanup because the oneshot connections seem to be firing early.
# This checks the key conditions before firing the oneshot connections.

# Signal that gets wired to:
# boss.wake_up
# body.stop_showing_boss_warning
# door.close
# door.lock
signal wake_up_boss()

func _on_body_enter(body):
	if body.is_in_group("player"):
		if !body.boss_defeated:
			emit_signal("wake_up_boss")
