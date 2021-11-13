extends Node2D

var arrow = load("res://Assets/crosshair.png")

onready var bullet_manager = $BulletManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	GlobalSignals.connect("bullet_fired",bullet_manager,"hanlde_bullet_spawner")
	Input.set_custom_mouse_cursor(arrow)
