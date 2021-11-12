extends Node2D

func hanlde_bullet_spawner(bullet: Bullet,position,direction):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)
