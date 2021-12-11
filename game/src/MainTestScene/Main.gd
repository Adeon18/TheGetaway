extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var queue

# Called when the node enters the scene tree for the first time.
func _ready():
	queue = $TurnQueue
	queue.initialize()
	queue.play_turn()

func _process(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
