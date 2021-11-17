extends Node2D
class_name MapAI

export (Team.TeamName) var team_name = Team.TeamName.NEUTRAL
export (PackedScene) var unit = null
export (int) var max_enemy_alive = 25
export (int) var max_enemy_to_spawn = 50

signal spwn_enemy(unit_instance)

onready var team = $Team
onready var unit_container = $UnitContainer
onready var respawn_timer = $RespawnTimer

var base = Vector2.ZERO
var respawn_points: Array = []
var reach_end: int = 0 

func initialize(location: Vector2,respwn: Array):
	if respwn.size() == 0 or unit == null:
		push_error("Forgot To Properly Initialize Our Map AI")
		return
	
	base = location
	team.team = team_name
	self.respawn_points = respwn
	respawn_timer.start()

func assign_base(unit: Actor):
		var ai: AI = unit.ai
		ai.base = base
		ai.set_state(AI.State.ADVANCE)
		
func spawn_unit(spawn_location: Vector2):
	if reach_end < max_enemy_to_spawn:
		var unit_instance = unit.instance()
		unit_container.add_child(unit_instance)
		unit_instance.global_position = spawn_location
		emit_signal("spwn_enemy",unit_instance)
		assign_base(unit_instance)
		reach_end += 1
	else:
		#victory game end
		pass


func _on_RespawnTimer_timeout() -> void:
	var respwn = respawn_points[randi() % respawn_points.size()]
	
	var timer: float = respawn_timer.wait_time
	if timer > 6:
		respawn_timer.wait_time = timer - 1
	elif timer < 6 and timer > 3:
		respawn_timer.wait_time = timer - 0.4
	else:
		respawn_timer.wait_time = timer + 0.2
		
	spawn_unit(respwn.global_position)
	
	if unit_container.get_children().size() < max_enemy_alive:
		respawn_timer.start()
