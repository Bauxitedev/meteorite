extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func init():
	Sound.play_sound_at("boss_explode", global_transform.origin)
