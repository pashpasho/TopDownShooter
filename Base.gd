extends Area2D

var damge = preload("res://damge.tscn")

onready var health_stat = $Health
onready var team = $Team


func get_team()-> int:
	return team.team

func handle_hit():
	health_stat.health -= 100
	var text = damge.instance()
	text.amount = 100
	add_child(text)
