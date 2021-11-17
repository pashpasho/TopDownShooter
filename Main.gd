extends Node2D

var arrow = load("res://Assets/crosshair.png")

onready var player: Player = $Player
onready var bullet_manager = $BulletManager
onready var enemy_ai = $EnemyMapAI
onready var canvs_lyer = $MiniMap/MiniMap2
onready var base = $house
onready var gui = $GUI
onready var tilemap = $Area/TileMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	GlobalSignals.connect("bullet_fired",bullet_manager,"hanlde_bullet_spawner")
	Input.set_custom_mouse_cursor(arrow)

	var enemy_respawns =$EnemyRespawnPoint

	enemy_ai.initialize(base.global_position,enemy_respawns.get_children())
	gui.set_player(player,base)
	canvs_lyer.set_ai(enemy_ai)
	
	
	for object in get_tree().get_nodes_in_group("minimap_objects"):
		object.connect("removed", $CanvasLayer/MiniMap, "_on_object_removed")
