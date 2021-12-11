extends KinematicBody2D

var step = 64


const WALL_LAYER = 4

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
var last_seen_pos: Vector2

var path: PoolVector2Array

var turn_dict = {
	Vector2(0, 1): 180,
	Vector2(1, 0): 90,
	Vector2(0, -1): 0,
	Vector2(-1, 0): 270,
	
}

var brein_stopped: bool = false
export var stop_brein_for: int = 3
var brein_was_stopped_for: int = 0

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
	if !brein_stopped:
		brein_was_stopped_for = 0
		cur_pos_tile = Tilemap.world_to_map(global_position)

		print(triggered)
		if look_for_player() or triggered:
			dest_pos_tile = Tilemap.world_to_map(last_seen_pos)
			path = Tilemap._get_path(cur_pos_tile, dest_pos_tile)
			if path:
				next_pos_vec = path[0] - cur_pos_tile
			else:
				triggered = false
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
	else:
		brein_was_stopped_for += 1
		if brein_was_stopped_for >= stop_brein_for:
			brein_stopped = false
			brein_was_stopped_for = 0


func brein_stop():
	brein_stopped = true

func get_class(): return "Enemy"

func look_for_player():
	var directState = get_world_2d().direct_space_state
	var targetPosition = Player.global_position
	var offset = global_position
	var collision = directState.intersect_ray(offset, targetPosition, [self])
	if collision["collider"].get_collision_layer() != WALL_LAYER:
		last_seen_pos = Player.global_position
		return true
	return false


func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		if look_for_player():
			triggered = true

