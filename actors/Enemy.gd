extends KinematicBody2D

var speed = 100
onready var health_stat = $Health

func handle_hit():
	health_stat.health -= 100
	if health_stat.health <=0 :
		queue_free()

func _physics_process(delta: float) -> void:
	if Global.Player == null:
		return
	var pos_to_plr = (Global.Player.global_position - global_position).normalized()
	
	move_and_collide(pos_to_plr*speed*delta)
	look_at(Global.Player.position)
