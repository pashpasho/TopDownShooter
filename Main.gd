extends Node2D

var arrow = load("res://Assets/crosshair.png")

onready var bullet_manager = $BulletManager
onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("palyer_fired_bullet",bullet_manager,"hanlde_bullet_spawner")
	Input.set_custom_mouse_cursor(arrow)
