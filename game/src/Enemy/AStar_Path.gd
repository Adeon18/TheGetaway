extends TileMap

class_name AStar_Path

const EMPTY_TILE_ID: int = 53

var neighbours = [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]

onready var used_cells = get_used_cells_by_id(EMPTY_TILE_ID)
onready var astar = AStar2D.new()


func _ready():
	_add_points()
	_connect_points()
	

func _add_points():
	for cell in used_cells:
		astar.add_point(id(cell), cell, 1.0)

func _connect_points():
	"""
	Connect the Path.
	"""
	for cell in used_cells:
		astar.add_point(id(cell), cell, 1.0)
		
		for neighbour in neighbours:
			var next_cell = cell + neighbour
			if used_cells.has(next_cell):
				astar.connect_points(id(cell), id(next_cell), false)

func _get_path(start, end):
	"""
	Get an Array Stating the path between 2 points from start to end.
	"""
	var path: PoolVector2Array
	path = astar.get_point_path(id(start), id(end))
	path.remove(0)

	return path


func id(point):
	"""
	Cantor Pairing function
	"""
	var a = point.x
	var b = point.y
	
	return (a + b) * (a + b + 1) / 2 + b


