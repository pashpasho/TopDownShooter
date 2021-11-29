extends Node2D

var arrow = load("res://Assets/crosshair.png")
const gameoverscreen = preload("res://Ui/GameOverScreen.tscn")
const pausescreen = preload("res://Ui/PauseScreen.tscn")
const gamewinscreen = preload("res://Ui/GameWinScreen.tscn")

onready var player: Player = $Player
onready var bullet_manager = $BulletManager
onready var enemy_map_ai = $EnemyMapAI
onready var canvs_lyer = $MiniMap/MiniMap2
onready var base = $house
onready var gui = $GUI
onready var ground = $Ground
onready var pathfinding = $Pathfinding

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	GlobalSignals.connect("bullet_fired",bullet_manager,"hanlde_bullet_spawner")
	Input.set_custom_mouse_cursor(arrow)

	var enemy_respawns =$EnemyRespawnPoint

	pathfinding.create_navigation_map(ground)
	
	enemy_map_ai.initialize(enemy_respawns.get_children(),pathfinding)
	gui.set_player(player,base)
	canvs_lyer.set_ai(enemy_map_ai)
	player.connect("died",self,"handle_player_lose")
	enemy_map_ai.connect("map_cleared",self,"handle_player_win")
	
	for object in get_tree().get_nodes_in_group("minimap_objects"):
		object.connect("removed", $CanvasLayer/MiniMap, "_on_object_removed")

func handle_player_lose():
	var game_over = gameoverscreen.instance()
	add_child(game_over)
	get_tree().paused = true

func handle_player_win():
	var game_win = gamewinscreen.instance()
	add_child(game_win)
	get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menue = pausescreen.instance()
		add_child(pause_menue)
