extends KinematicBody2D

var step = 32
var moveVector = Vector2()
var canMove = true

var targetPosition = Vector2()
var lerpSpeed = 30

func _physics_process(delta):
	if canMove:
		process_movement()
		targetPosition = global_position + moveVector*step
		moveVector = Vector2()
		canMove = false
	
	# Interpolate position of player for smooth movement
	if not canMove:
		if (abs(global_position.x - targetPosition.x) > 0.01) or (abs(global_position.y - targetPosition.y) > 0.01):
			global_position = lerp(global_position, targetPosition, lerpSpeed*delta)
		else:
			global_position = targetPosition
			canMove = true


func process_movement():
	if Input.is_action_just_pressed("ui_up"):
		moveVector = Vector2.UP
	elif Input.is_action_just_pressed("ui_down"):
		moveVector = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_right"):
		moveVector = Vector2.RIGHT
	elif Input.is_action_just_pressed("ui_left"):
		moveVector = Vector2.LEFT
