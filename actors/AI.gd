extends Node2D
class_name AI


signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE,
	PAUSE,
}


export (bool) var should_draw_path_line := true


onready var patrol_timer = $PatrolTimer
onready var path_line = $PathLine

var position_check := Vector2.ZERO
var current_state: int = -1 setget set_state
var actor: Actor = null
var target: KinematicBody2D = null
var weapon: weapon = null
var team: int = -1

# PATROL STATE
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var actor_velocity: Vector2 = Vector2.ZERO


var pathfinding: Pathfinding

func _ready() -> void:
	set_state(State.PATROL)
	path_line.visible = should_draw_path_line


func _physics_process(delta: float) -> void:
	path_line.global_rotation = 0
	match current_state:
		State.PAUSE:
			pass
		State.PATROL:
			if not patrol_location_reached and patrol_location != Vector2.ZERO:
				var path = pathfinding.get_new_path(global_position, patrol_location)
				if path.size() > 1:
					actor_velocity = actor.velocity_toward(path[1])
					actor.rotate_toward(path[1])
					actor.move_and_slide(actor_velocity)
					set_path_line(path)
				else:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
					path_line.clear_points()
		State.ENGAGE:
			if target != null:
				actor.rotate_toward(target.global_position)
				actor_velocity = actor.velocity_toward(target.global_position) * 1.8
				actor.move_and_slide(actor_velocity)
			else:
				print("In the engage state but no weapon/target")
		_:
			print("Error: found a state for our enemy that should not exist")


func initialize(actor: KinematicBody2D, weapon: weapon, team: int):
	self.actor = actor
	self.weapon = weapon
	self.team = team
	
	if weapon != null:
		weapon.connect("weapon_out_of_ammo", self, "handle_reload")


func set_path_line(points: Array):
	if not should_draw_path_line:
		return

	var local_points := []
	for point in points:
		if point == points[0]:
			local_points.append(Vector2.ZERO)
		else:
			local_points.append(point - global_position)

	path_line.points = local_points


func flash_detected(player):
	target = player
	set_state(State.ENGAGE)


func set_state(new_state: int):
	if new_state == current_state:
		return

	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true


	current_state = new_state
	emit_signal("state_changed", current_state)


func handle_reload():
	weapon.start_reload()


func _on_PatrolTimer_timeout() -> void:
	var patrol_range = 1000
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false


func _on_DetectionZone_body_entered(body: Node) -> void:
	if body.has_method("get_team") and body.get_team() != team:
		set_state(State.ENGAGE)
		target = body


func _on_DetectionZone_body_exited(body: Node) -> void:
	if target and body == target:
		set_state(State.PATROL)
		target = null


func _on_StuckTimer_timeout() -> void:
	if position_check - global_position < Vector2(3, 3):
		patrol_location_reached = true
		actor_velocity = Vector2.ZERO
		origin = position_check
		patrol_timer.start()
		path_line.clear_points()
		
	position_check = global_position
	
