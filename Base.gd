extends Area2D
class_name House

var damge = preload("res://damge.tscn")
signal base_health_changed(new_health)

onready var health_stat = $Health
onready var team = $Team


func get_team()-> int:
	return team.team

func handle_hit():
	health_stat.health -= 100
	emit_signal("base_health_changed",health_stat.health)
	var text = damge.instance()
	text.amount = 100
	add_child(text)
