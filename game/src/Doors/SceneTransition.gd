extends CanvasLayer


signal scene_changed()

onready var anim_player := $AnimationPlayer
onready var screen := $Control/ColorRect
# This timer waits for a small time for a level to be loaded and objects - reloaded.
onready var wait_timer: Timer = $ReloadObjTimer


func _ready() -> void:
	"""
	Set the screen to invisible for optimisation purposes.
	"""
	screen.visible = false


func change_scene(path):
	"""
	
	"""
	anim_player.play("fadein")
	yield(anim_player, "animation_finished")

	if get_tree().change_scene_to(path) != OK:
		print("Error occured while loading the scene from other scene.")

	anim_player.play("fadeout")
	yield(anim_player, "animation_finished")

	emit_signal("scene_changed")

