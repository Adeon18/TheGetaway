extends KinematicBody2D

var step = 16
var moveVector = Vector2()

signal finish_turn

func make_turn():
	moveVector = Vector2.RIGHT
	global_position += moveVector * step
	emit_signal("finish_turn")

func get_class(): return "Enemy"
