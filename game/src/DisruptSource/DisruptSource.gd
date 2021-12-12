extends Node2D

var is_active = false
onready var active_timer = $ActiveTimer
onready var PopuPWindow = get_node("../CanvasLayer/Popup")

func alert_enemies():
	var bodies = $DisruptRadius.get_overlapping_bodies()
	is_active = true
	$ActiveStreamPlayer2D.play()
	PopuPWindow.window_popup({1: "aaaaggghhhh, he is stopping is."})
	for body in bodies:
		if body.has_method("disturb_enemy"):
			body.disturb_enemy(global_position)
			active_timer.start()
