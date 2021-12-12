extends "res://src/DisruptSource/DisruptSource.gd"

onready var radius = $DisruptRadius/CollisionShape2D

func _ready():
	radius.scale.x = 10
	radius.scale.y = 10

func _process(delta):
	if is_active and active_timer.is_processing():
		$AnimatedSprite.animation = "hacked"
	else:
		$AnimatedSprite.animation = "default"
		is_active = false
