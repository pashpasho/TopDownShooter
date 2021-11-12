extends KinematicBody2D

export (PackedScene) var Bullet
export var speed = 100

var health: int = 100

signal palyer_fired_bullet(bullet,position,direction)

onready var end_of_gun = $EndofGun
onready var gun_direction = $GunDirection
onready var attackcolldown = $AttackColdown
onready var animation_player = $AnimationPlayer

func _ready():
	pass # Replace with function body.

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
				shoot()

func shoot():
	if attackcolldown.is_stopped():
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		emit_signal("palyer_fired_bullet",bullet_instance,end_of_gun.global_position,direction)
		attackcolldown.start()
		animation_player.play("muzzle_flash")


func handle_hit():
	health -= 20
	print("Player Hit",health)
