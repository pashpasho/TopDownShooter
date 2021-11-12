extends KinematicBody2D

export (bool) var wepn
export var speed = 100

onready var health_stat = $Health
onready var ai = $AI
onready var weapon = $Weapon


func _ready() -> void:
	if	wepn:
		ai.initialize(self, weapon)
	else:
		ai.initialize(self, null)
		weapon.visible = false

func handle_hit():
	health_stat.health -= 100
	if health_stat.health <=0 :
		queue_free()

func rotate_toward(location: Vector2):
	rotation = lerp(rotation, global_position.direction_to(location).angle(),0.1)

func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
