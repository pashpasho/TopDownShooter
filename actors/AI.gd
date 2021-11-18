extends Node2D
class_name AI

signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE,
	ADVANCE
}

onready var patrol_timer = $Patrol_Time

var actor: Actor = null
var current_state: int = -1 setget set_state
var target = null
var weapon: weapon = null
var actor_velocity: Vector2 = Vector2.ZERO
var team: int = -1
var house: House

var pathfinding: Pathfinding

#PATROL_STATE
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached := false

#ADVANCE_STATE
var base: Vector2 = Vector2.ZERO
	
	
func _physics_process(delta: float) -> void:
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				actor_velocity = actor.velocity_toward(patrol_location)
				actor.move_and_slide(actor_velocity)
				actor.rotate_toward(patrol_location)
				if actor.has_reached_position(patrol_location):
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()		
		State.ENGAGE:
			if target != null:
				var angle_to_target = actor.global_position.direction_to(target.global_position).angle()
				actor.rotate_toward(target.global_position)
				if weapon != null and abs(actor.rotation-angle_to_target) < 0.1:
					weapon.shoot()
				else:
					var pos_to_plr: Vector2= (target.global_position - global_position).normalized()
					actor.move_and_collide(pos_to_plr*100*delta)
		State.ADVANCE:
			#optimization if you want to have beter pathfinding and optimization for each frame
			var path = pathfinding.get_new_path(global_position, base)
			if path.size() > 1 and not actor.has_reached_position(base):
				actor_velocity = actor.velocity_toward(path[1])
				actor.rotate_toward(path[1])
				actor.move_and_slide(actor_velocity)
			else:
				set_state(State.ENGAGE)
		_:
			print("Error:state dosn^t exists...")


func initialize(actor: KinematicBody2D, weapon: weapon, team: int):
	self.actor = actor
	self.weapon = weapon
	self.team = team
	if weapon != null:
		weapon.connect("weapon_out_of_ammo",self,"handle_reload")
	
func handle_reload():
	weapon.start_reload()	
	
func set_state(new_state: int):
	if new_state == current_state:
		return
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	
	elif new_state == State.ADVANCE:
		if actor.has_reached_position(base):
			set_state(State.ENGAGE)
	
	
	current_state = new_state
	emit_signal("state_changed",current_state)



func _on_Patrol_Time_timeout() -> void:
	var patrol_range = 50
	var random_x = rand_range(-patrol_range,patrol_range)
	var random_y = rand_range(-patrol_range,patrol_range)
	patrol_location = Vector2(random_x,random_y) + origin
	patrol_location_reached = false


func _on_DetectionZone_body_entered(body: Node) -> void:
	if body.has_method("get_team") and body.get_team() != team:
		set_state(State.ENGAGE)
		target = body


func _on_DetectionZone_body_exited(body: Node) -> void:
	if target and body == target:
		set_state(State.ADVANCE)
		target = null




func _on_DetectionZone_area_entered(area: Area2D) -> void:
	if area.has_method("get_team") and area.get_team() != team:
		set_state(State.ENGAGE)
		target = area


