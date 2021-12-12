extends Control


onready var WhatTheFuckIsMusicPlayerDoingHereLol = get_node("../../MusicPlayer")


func _ready():
	$Label.text = get_tree().get_current_scene().get_name()
	WhatTheFuckIsMusicPlayerDoingHereLol.play()
	
