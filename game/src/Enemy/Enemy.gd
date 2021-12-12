extends KinematicBody2D

var step = 64
export var sight_dist = 300


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

var disturbed: bool = false
var distruption_source: Vector2

enum STATE {IDLE, TRANSITIONING}
var current_state = STATE.IDLE

var target_position = Vector2()
var lerp_speed = 30

onready var Tilemap: TileMap = get_node("../../TileMap")
onready var Player: Player = get_parent().get_node("Player")
onready var PlayerDetector = get_node("PlayerDetector")
onready var PatroolPointA = get_node("PatroolPointA")
onready var PatroolPointB = get_node("PatroolPointB")
onready var FOVLight = get_node("FOVLight")
onready var Raycast = get_node("RayCast2D")
onready var Turnqueue = get_parent()

var enemy_texture
var enemy_alerted_texture
onready var enemy_sprite = $SpriteContainer/Sprite

var turn_finished = false
signal finish_turn


func _ready():
	enemy_texture = load("res://art/Enemy/enemy.png")
	enemy_alerted_texture = load("res://art/Enemy/enemy_alerted.png")



func _physics_process(delta):
	if current_state == STATE.TRANSITIONING:
		if (abs(global_position.x - target_position.x) > 0.01) or (abs(global_position.y - target_position.y) > 0.01):
			global_position = lerp(global_position, target_position, lerp_speed*delta)
		else:
			global_position = target_position
			current_state = STATE.IDLE

func make_turn():
	"""
	Make a turn, get the current pos and the dest pos.
	"""
	if !brein_stopped:
		brein_was_stopped_for = 0
		cur_pos_tile = Tilemap.world_to_map(global_position)

		if look_for_player() or triggered:
			# clear distruption
			disturbed = false
			distruption_source = Vector2.ZERO

			dest_pos_tile = Tilemap.world_to_map(last_seen_pos)
			path = Tilemap._get_path(cur_pos_tile, dest_pos_tile)
			if path:
				next_pos_vec = path[0] - cur_pos_tile
			else:
				triggered = false
				enemy_sprite.texture = enemy_texture
		elif disturbed == false:
			# clear distruption
			distruption_source = Vector2.ZERO

			# if dest is point A
			if (curr_patrool_target):
				dest_pos_tile = Tilemap.world_to_map(PatroolPointA.global_position)
			# if dest is point B
			else:
				dest_pos_tile = Tilemap.world_to_map(PatroolPointB.global_position)
			# find path
			path = Tilemap._get_path(cur_pos_tile, dest_pos_tile)
			if path:
				# if tehre is path, move
				next_pos_vec = path[0] - cur_pos_tile
			else:
				# else, change patrool target, clear movement direction, set wait
				curr_patrool_target = !curr_patrool_target
				next_pos_vec = Vector2.ZERO
				is_waiting = true
		elif disturbed:
			# if disturbed, move to the location of disturption
			dest_pos_tile = Tilemap.world_to_map(distruption_source)
			path = Tilemap._get_path(cur_pos_tile, dest_pos_tile)
			if path:
				# if there is path, move
				next_pos_vec = path[0] - cur_pos_tile
			else:
				# clear distruption and next pos vector
				disturbed = false
				next_pos_vec = Vector2.ZERO
				distruption_source = Vector2.ZERO
		
		if is_waiting: 
			# if you are waiting - clear movement
			next_pos_vec = Vector2.ZERO
			curr_waited += 1


		if Turnqueue.positions.find(Tilemap.world_to_map(global_position + next_pos_vec*step)) != -1:
			next_pos_vec = Vector2.ZERO
		else:
			Turnqueue.positions.append(Tilemap.world_to_map(global_position + next_pos_vec*step))
			var idx = Turnqueue.positions.find(Tilemap.world_to_map(global_position))
			Turnqueue.positions.remove(idx)
		
#		global_position += next_pos_vec * step
		
		

		if next_pos_vec != Vector2.ZERO:
			PlayerDetector.rotation_degrees = turn_dict[next_pos_vec]
			FOVLight.rotation_degrees = turn_dict[next_pos_vec]+90
			Raycast.rotation_degrees = turn_dict[next_pos_vec]+180
		var collide_with = Raycast.get_collider()

		target_position = global_position + next_pos_vec * step
		current_state = STATE.TRANSITIONING
		
		
		
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
	var dif_in_dists = global_position - Player.global_position
	var dist_to = sqrt(dif_in_dists.x * dif_in_dists.x + dif_in_dists.y*dif_in_dists.y)
	if dist_to < sight_dist:
		var directState = get_world_2d().direct_space_state
		var targetPosition = Player.global_position
		var offset = global_position
		var collision = directState.intersect_ray(offset, targetPosition, [self])
		if collision["collider"].get_collision_layer() != WALL_LAYER:
			last_seen_pos = Player.global_position
			return true
	return false


func disturb_enemy(source_gloal_position: Vector2):
	distruption_source = source_gloal_position
	disturbed = true


func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		if look_for_player():
			triggered = true
			enemy_sprite.texture = enemy_alerted_texture

