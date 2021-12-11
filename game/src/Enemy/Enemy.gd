extends KinematicBody2D

var step = 64


var cur_pos_tile
var dest_pos_tile
var next_pos_vec: Vector2
var prev_pos_vec: Vector2 = Vector2(0, 1)
var rnd_dir_choice: int

# FALSE : PointA
# TRUE : PointB
var curr_patrool_target: bool = false
export var wait_in_patrool_points: int = 2
var curr_waited: int = 0
var is_waiting: bool = false

var directions: Array = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]


var triggered: bool = false

var path: PoolVector2Array

var turn_dict = {
	Vector2(0, 1): 180,
	Vector2(1, 0): 90,
	Vector2(0, -1): 0,
	Vector2(-1, 0): 270,
	
}

onready var Tilemap: TileMap = get_node("../../TileMap")
onready var Player: Player = get_parent().get_node("Player")
onready var PlayerDetector = get_node("PlayerDetector")
onready var PatroolPointA = get_node("PatroolPointA")
onready var PatroolPointB = get_node("PatroolPointB")

signal finish_turn


func _ready():
	pass


func make_turn():
	"""
	Make a turn, get the current pos and the dest pos.
	"""
	cur_pos_tile = Tilemap.world_to_map(global_position)
	
	if triggered:

		dest_pos_tile = Tilemap.world_to_map(Player.global_position)
		path = Tilemap._get_path(cur_pos_tile, dest_pos_tile)
		if path:
			next_pos_vec = path[0] - cur_pos_tile
	else:
		# if dest is point A
		if (curr_patrool_target):
			dest_pos_tile = Tilemap.world_to_map(PatroolPointA.global_position)
		# if dest is point B
		else:
			dest_pos_tile = Tilemap.world_to_map(PatroolPointB.global_position)
		# find path
		path = Tilemap._get_path(cur_pos_tile, dest_pos_tile)
		if path:
			next_pos_vec = path[0] - cur_pos_tile
		else:
			curr_patrool_target = !curr_patrool_target
			next_pos_vec = Vector2.ZERO
			is_waiting = true
	
	if is_waiting: 
		next_pos_vec = Vector2.ZERO
		curr_waited += 1
	
	global_position += next_pos_vec * step

	if next_pos_vec != Vector2.ZERO:
		PlayerDetector.rotation_degrees = turn_dict[next_pos_vec]
	prev_pos_vec = next_pos_vec
	PatroolPointA.global_position -= prev_pos_vec * step
	PatroolPointB.global_position -= prev_pos_vec * step
	if curr_waited >= wait_in_patrool_points:
		is_waiting = false
		curr_waited = 0



func get_class(): return "Enemy"


func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		triggered = true
