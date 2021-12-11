extends KinematicBody2D

var step = 64


var cur_pos_tile
var dest_pos_tile
var next_pos_vec: Vector2
var prev_pos_vec: Vector2 = Vector2(0, 1)
var possible_next_poss: Array
var rnd_dir_choice: int

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


signal finish_turn


func _ready():
	RndGen.randomize()


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
		pass
				
	global_position += next_pos_vec * step
#	print(turn_dict[next_pos_vec])
	PlayerDetector.rotation_degrees = turn_dict[next_pos_vec]
	prev_pos_vec = next_pos_vec



func get_class(): return "Enemy"


func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		triggered = true
