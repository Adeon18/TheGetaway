extends Area2D

export var next_scene: PackedScene
# A var to activate/deactivate doors
export var activated: bool = true
# Link to player
var player = null
# A bool which tells us if the level was changed
var level_changed: bool = false

var door_look: Dictionary = {
	"activated": "res://art/Doors/opened_door.png",
	"deactivated": "res://art/Doors/closed_door.png"
}

func _ready():
	if activated:
		$Sprite.texture = load(door_look["activated"])
		$CollisionShape2D.disabled = true
	else:
		$Sprite.texture = load(door_look["deactivated"])
		$CollisionShape2D.disabled = false


func _on_PlayerDetector_body_entered(body):
	if activated and body.name == "Player":
		player = body
		SceneTransition.change_scene(next_scene)
