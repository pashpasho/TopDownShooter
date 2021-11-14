extends Node2D

onready var team = $Team
var base = Vector2.ZERO

func initialize(location: Vector2):
	base = location
	assign_base()

func assign_base():
	for unit in get_children():
		var ai: AI = unit.ai
		ai.base = base
		ai.set_state(AI.State.ADVANCE)
		
