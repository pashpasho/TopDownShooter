extends KinematicBody2D
class_name Player

export var speed = 100

onready var health_stat = $Health
onready var weapon = $Weapon

signal palyer_fired_bullet(bullet,position,direction)


func _ready():
	weapon.connect("weapon_fired",self,"shoot")

func _physics_process(delta: float) -> void:
	var movement := Vector2.ZERO
	Global.Player = self
	
	if Input.is_action_pressed("up"):
		movement.y -= 1
	if Input.is_action_pressed("down"):
		movement.y += 1
	if Input.is_action_pressed("left"):
		movement.x -= 1
	if Input.is_action_pressed("right"):
		movement.x += 1
	
	movement = movement.normalized() * speed
	movement = move_and_slide(movement)

	look_at(get_global_mouse_position())

func _unhandled_input(event):
		if event.is_action_released("shoot"):
				weapon.shoot()

func shoot(bullet_instance,location: Vector2,direction: Vector2):
	emit_signal("palyer_fired_bullet",bullet_instance,location,direction)


func handle_hit():
	health_stat.health -= 20
	print("Player Hit",health_stat.health)
