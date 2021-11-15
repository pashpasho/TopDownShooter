extends Node2D

export (Team.TeamName) var team_name = Team.TeamName.NEUTRAL
export (PackedScene) var unit = null
export (int) var max_enemy_alive = 25
export (int) var max_enemy_to_spawn = 50

onready var team = $Team
onready var unit_container = $UnitContainer
onready var respawn_timer = $RespawnTimer

var base = Vector2.ZERO
var respawn_points: Array = []
var next_spawn_use: int = 0
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
		unit_instance.connect("died", self, "handle_unit_death")
		assign_base(unit_instance)
		reach_end += 1
	else:
		pass

func handle_unit_death():
	if respawn_timer.is_stopped() and unit_container.get_children().size() < max_enemy_alive:
		respawn_timer.start()


func _on_RespawnTimer_timeout() -> void:
	var respwn = respawn_points[next_spawn_use]
	spawn_unit(respwn.global_position)
	next_spawn_use += 1
	
	if next_spawn_use == respawn_points.size():
		next_spawn_use = 0
	
	if unit_container.get_children().size() < max_enemy_alive:
		respawn_timer.start()
