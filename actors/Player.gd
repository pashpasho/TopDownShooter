extends KinematicBody2D
class_name Player

export var speed = 100

onready var light = get_node("Light2D")

onready var health_stat = $Health
onready var weapon: weapon = $Weapon
onready var team = $Team

func _ready() -> void:
	weapon.initialize(team.team)

func _physics_process(delta: float) -> void:
	var movement := Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		movement.y -= 1
	if Input.is_action_pressed("down"):
		movement.y += 1
	if Input.is_action_pressed("left"):
		movement.x -= 1
	if Input.is_action_pressed("right"):
		movement.x += 1
		
	if Input.is_action_just_pressed("f"):
		light.visible = !light.visible
	
	movement = movement.normalized() * speed
	movement = move_and_slide(movement)

	look_at(get_global_mouse_position())

func get_team()-> int:
	return team.team

func _unhandled_input(event):
	if event.is_action_released("shoot"):
			weapon.shoot()
	elif event.is_action_released("reload"):
			weapon.start_reload()	
						
func reload():
	weapon.start_reload()

func handle_hit():
	health_stat.health -= 20
	print("Player Hit",health_stat.health)
