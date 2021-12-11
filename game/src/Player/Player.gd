extends KinematicBody2D

class_name Player

const WALL_LAYER = 4
var step = 64
var moveVector = Vector2()
var canMove = true

var targetPosition = Vector2()
var lerpSpeed = 30

signal finish_turn

func _physics_process(delta):
	if canMove:
		moveVector = Vector2()
		process_movement()
		if moveVector != Vector2.ZERO:
			emit_signal("finish_turn")
			var directState = get_world_2d().direct_space_state
			targetPosition = global_position + moveVector*step
			var playerOffset = global_position + moveVector*16
			var collision = directState.intersect_ray(playerOffset, targetPosition)
			
			# Check if target position is not wall
			if collision["collider"].get_collision_layer() != WALL_LAYER:
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

func make_turn():
	pass
# OLEXIY GAVNOCODE
func get_class(): return "Player"
