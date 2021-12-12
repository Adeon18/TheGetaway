extends Button


var PopupWindow: Control


func _on_ButtonLOL_pressed():
	PopupWindow = get_node("../Popup")
	PopupWindow.window_popup({
	1: "Wake up Samurai", 
	2: "Wake up...", 
	3: "Go fuck yourself"
})
