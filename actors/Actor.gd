extends KinematicBody2D
class_name Actor

export (bool) var wepn = false
export var speed = 100

signal dead(unit)

onready var collision_shape = $CollisionShape2D
onready var health_stat = $Health
onready var weapon: weapon = $Weapon
onready var team = $Team
onready var ai = $AI
var player: Player

var minimap_icon = "mob"

#Damage section
var stun = false

export var knockback_speed = 1100
var knockback = Vector2.ZERO
export(int) var screen_shake = 120

onready var current_color = modulate

func _ready() -> void:
	if wepn:
		ai.initialize(self, weapon, team.team)
		weapon.initialize(team.team)
	else:
		weapon.hide()
		ai.initialize(self, null, team.team)



func get_team() -> int: 
	return team.team


func _physics_process(delta: float) -> void:
	if stun:
		player.move_and_slide(knockback) 
	
func has_reached_position(location: Vector2) -> bool:
	return global_position.distance_to(location) < 250

func handle_hit():
	health_stat.health -= 100
	if health_stat.health <=0 :
		emit_signal("dead",self)
		queue_free()

func rotate_toward(location: Vector2):
	rotation = lerp(rotation, global_position.direction_to(location).angle(),0.1)

func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed


func _on_damage_box_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.modulate = Color.red
		player = body
		stun = true
		body.handle_hit(100)
		knockback = global_position.direction_to(player.global_position) * knockback_speed
		$Stun_Timer.start()


func _on_Stun_Timer_timeout() -> void:
	player.modulate = Color.white
	stun = false
