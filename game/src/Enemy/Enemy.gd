extends KinematicBody2D

var step = 64
var moveVector = Vector2()

var cur_pos_tile
var dest_pos_tile
var next_pos_vec: Vector2

var path: PoolVector2Array

onready var Tilemap: TileMap = get_node("../../TileMap")
onready var Player: Player = get_parent().get_node("Player")


signal finish_turn


func make_turn():
	"""
	Make a turn, get the current pos and the dest pos.
	"""
	cur_pos_tile = Tilemap.world_to_map(global_position)
	dest_pos_tile = Tilemap.world_to_map(Player.global_position)
	
	path = Tilemap._get_path(cur_pos_tile, dest_pos_tile)
	
	if path:
		next_pos_vec = path[0] - cur_pos_tile
	
	moveVector = Vector2.RIGHT
	global_position += next_pos_vec * step
	

func get_class(): return "Enemy"
