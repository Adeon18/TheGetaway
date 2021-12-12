extends Node2D


export var messages = {
	1: "Wake up Samurai", 
	2: "Wake up...", 
	3: "Go fuck yourself"
}

export var typing_speed: float = 0.13
export var in_window = false


var message_cooldown = 1.5

var current_message = 1
var current_display = "_"
var current_char = 0

var ParentPopupWindow

onready var LabelObj: Label = get_node("Label")
onready var NextCharT: Timer = get_node("NextCharTimer")
onready var NextMessT: Timer = get_node("NextMessageTimer")


func _ready():
	if in_window:
		ParentPopupWindow = get_node("../..")


func set_messages(new_messages):
	"""
	Set the message from outside(Used in PopUpWindow)
	"""
	messages = new_messages
	start_dialogue()


func start_dialogue():
	current_message = 1
	current_display = "_"
	current_char = 0
	
	NextCharT.set_wait_time(typing_speed)
	NextCharT.start()

func stop_dialogue():
	if in_window:
		ParentPopupWindow.window_hide()
	else:
	# TODO: Here should be The fadeout screen.
		queue_free()

func clear_prompt():
	"""
	Clears the prompt
	"""
	current_display = ""
	LabelObj.text = current_display


func _on_NextCharTimer_timeout():
	if (current_char < len(messages[current_message])):
		current_display.erase(current_display.length() - 1, 1)
		var next_char = messages[current_message][current_char]
		current_display += next_char
		current_display += "_"
		
		LabelObj.text = current_display
		current_char += 1
	else:
		NextCharT.stop()
		NextMessT.one_shot = true
		NextMessT.set_wait_time(message_cooldown)
		NextMessT.start()


func _on_NextMessageTimer_timeout():
	if (current_message == len(messages)):
		stop_dialogue()
	else:
		current_message += 1
		current_display = ""
		current_char = 0
		NextCharT.start()

