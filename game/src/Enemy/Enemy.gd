extends KinematicBody2D

var step = 64
var moveVector = Vector2()

var cur_pos_tile
var dest_pos_tile

var path: PoolVector2Array

onready var Tilemap: TileMap = get_node("../../TileMap")
onready var Player: Player = get_parent().get_node("Player")

signal finish_turn

func make_turn():
#	print(used_cells)
	
	cur_pos_tile = Tilemap.world_to_map(global_position)
	dest_pos_tile = Tilemap.world_to_map(Player.global_position)
	
	path = Tilemap._get_path(cur_pos_tile, dest_pos_tile)
	
	
	var next_pos = path[0] - cur_pos_tile
	
	print(path[0])
	
	moveVector = Vector2.RIGHT
	global_position += next_pos * step
	

func get_class(): return "Enemy"
