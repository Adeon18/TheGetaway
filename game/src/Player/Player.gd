extends KinematicBody2D

var step = 32

func _physics_process(delta):
	var moveVector = Vector2()
	if Input.is_action_just_pressed("ui_up"):
		moveVector = Vector2.UP
	elif Input.is_action_just_pressed("ui_down"):
		moveVector = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_right"):
		moveVector = Vector2.RIGHT
	elif Input.is_action_just_pressed("ui_left"):
		moveVector = Vector2.LEFT
		
	global_position += moveVector*step
