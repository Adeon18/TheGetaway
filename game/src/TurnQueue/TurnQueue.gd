extends Node2D

class_name TurnQueue

var active_char




func _ready():
	active_char = get_child(0)
	play_turn()


func play_turn():
	if(active_char.get_class() == "Player"):
		yield(active_char, "finish_turn")
	else:
		active_char.make_turn()
	var new_index : int = (active_char.get_index() + 1) % get_child_count()
	print(new_index)
	print(active_char)
	active_char = get_child(new_index)
	play_turn()

