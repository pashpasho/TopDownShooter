extends KinematicBody2D
class_name Actor

export (bool) var wepn = true
export var speed = 100

signal dead(unit)

onready var health_stat = $Health
onready var ai = $AI
onready var weapon: weapon = $Weapon
onready var team = $Team

var minimap_icon = "mob"

func _ready() -> void:
	if	wepn:
		ai.initialize(self, weapon, team.team)
		weapon.initialize(team.team)
	else:
		ai.initialize(self, null, team.team)
		weapon.visible = false

func get_team() -> int:
	return team.team

func has_reached_position(location: Vector2) -> bool:
	return global_position.distance_to(location) < 250

func handle_hit():
	health_stat.health -= 100
	if health_stat.health <=0 :
		emit_signal("dead",self)
		queue_free()

func rotate_toward(location: Vector2):
	rotation = lerp(rotation, global_position.direction_to(location).angle(),0.1)

func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed
