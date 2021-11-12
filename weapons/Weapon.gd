extends Node2D
class_name weapon


export (PackedScene) var Bullet

onready var end_of_gun = $EndofGun
onready var gun_direction = $GunDirection
onready var attackcolldown = $AttackColdown
onready var animation_player = $AnimationPlayer

func	shoot():
	if attackcolldown.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instance()
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		GlobalSignals.emit_signal("bullet_fired",bullet_instance,end_of_gun.global_position,direction)
		attackcolldown.start()
		animation_player.play("muzzle_flash")

