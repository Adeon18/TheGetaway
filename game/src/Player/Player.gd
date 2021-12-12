extends KinematicBody2D

class_name Player

const WALL_LAYER = 4
const ENEMY_LAYER = 2
var step = 64
var moveVector = Vector2()

enum STATE {IDLE, TRANSITIONING, SELECTING_ATTACK}
var currentState = STATE.IDLE

var targetPosition = Vector2()
var lerpSpeed = 30

onready var selectionSprite = $SelectionSprite
var selectionTexture
var selectionRefusedTexture

signal finish_turn

func _ready():
	selectionTexture = load("res://art/Player/selection.png")
	selectionRefusedTexture = load("res://art/Player/selection_refused.png")

func _physics_process(delta):
	if currentState == STATE.IDLE:
		moveVector = Vector2()
		process_movement()
		if moveVector != Vector2.ZERO:
			emit_signal("finish_turn")
			var directState = get_world_2d().direct_space_state
			targetPosition = global_position + moveVector*step
			var playerOffset = global_position + moveVector*step/2
			var collision = directState.intersect_ray(playerOffset, targetPosition)
			# Check if target position is not wall
			if collision["collider"].get_collision_layer() != WALL_LAYER:
				moveVector = Vector2()
				currentState = STATE.TRANSITIONING
		else:
			if Input.is_action_just_pressed("attack"):
				currentState = STATE.SELECTING_ATTACK
	elif currentState == STATE.SELECTING_ATTACK:
		process_atack()
		
	# Interpolate position of player for smooth movement
	elif currentState == STATE.TRANSITIONING:
		if (abs(global_position.x - targetPosition.x) > 0.01) or (abs(global_position.y - targetPosition.y) > 0.01):
			global_position = lerp(global_position, targetPosition, lerpSpeed*delta)
		else:
			global_position = targetPosition
			currentState = STATE.IDLE


func process_atack():
	if Input.is_action_just_pressed("attack"):
		selectionSprite.visible = false
		currentState = STATE.IDLE
		return
	
	selectionSprite.visible = true
	selectionSprite.global_position = (get_global_mouse_position()/step).floor() * step
	selectionSprite.global_position.x += step/2
	selectionSprite.global_position.y += step/2
	var reachable = true
	if selectionSprite.global_position.distance_to(global_position) > 3*step:
		reachable = false
		selectionSprite.texture = selectionRefusedTexture
	else:
		selectionSprite.texture = selectionTexture
	
	if Input.is_action_just_pressed("left_click") and reachable:
		var directState = get_world_2d().direct_space_state
		var collision = directState.intersect_ray(selectionSprite.global_position, selectionSprite.global_position, [self])
		if collision and collision["collider"].get_collision_layer() == ENEMY_LAYER:
			print("Enemy Hit")
			emit_signal("finish_turn")
			currentState = STATE.IDLE
			selectionSprite.visible = false

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
