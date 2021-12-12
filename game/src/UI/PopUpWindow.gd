extends Control


onready var DynamicText = get_node("Window/DynamicText")
onready var AnimPlayer: AnimationPlayer = get_node("AnimationPlayer")


func window_popup(phrase_dict):
	
	AnimPlayer.play("popup")
	yield(AnimPlayer, "animation_finished")
	DynamicText.set_messages(phrase_dict)


func window_hide():
	""""""
	AnimPlayer.play("hide")
	yield(AnimPlayer, "animation_finished")
	DynamicText.clear_prompt()
