extends Node2D

var is_active = false
onready var active_timer = $ActiveTimer

func alert_enemies():
	var bodies = $DisruptRadius.get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		if body.has_method("disturb_enemy"):
			body.disturb_enemy(global_position)
			is_active = true
			active_timer.start()
