extends KinematicBody2D

var health := 100
var speed = 100

func handle_hit():
	health -= 100
	if health <=0 :
		queue_free()

func _physics_process(delta: float) -> void:
	if Global.Player == null:
		return
	var pos_to_plr = (Global.Player.global_position - global_position).normalized()
	
	move_and_collide(pos_to_plr*speed*delta)
	look_at(Global.Player.position)
