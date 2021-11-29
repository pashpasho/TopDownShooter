extends MarginContainer

export (NodePath) var player  # Link to Player node. If this is null, the map will not function.
export var zoom = 1.5 setget set_zoom # Scale multiplier.

var map_ai: MapAI

# Node references.
onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/PlayerMarker
onready var mob_marker = $MarginContainer/Grid/MobMarker
onready var alert_marker = $MarginContainer/Grid/AlertMarker
# Link object icon setting to Sprite marker.
onready var icons = {"mob": mob_marker, "alert": alert_marker}


var grid_scale  # Calculated world to map scale.
var markers = {}  # Dictionary of object: marker.

func set_ai(mapai):
	self.map_ai = mapai
	map_ai.connect("spwn_enemy",self,"add_enemy_in_minimap")

func _ready():
	var a = 5
	if a in range(6, 10):
		print("in")
	# Center the player marker in the grid.
	player_marker.position = grid.rect_size / 2
	# Find the scale factor for marker placement.
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	# Create markers for all objects.

func add_enemy_in_minimap(unit_instance: Actor):
	var new_marker = icons[unit_instance.minimap_icon].duplicate()
	grid.add_child(new_marker)
	new_marker.show()
	markers[unit_instance] = new_marker
	unit_instance.connect("dead",self,"_on_object_removed")

func _process(delta):
	# If no player is assigned, do nothing.
	if !player:
		return
	# Arrow texture points upwards, so add 90 degrees.
	player_marker.rotation = get_node(player).rotation + PI/2
	for item in markers:
		var obj_pos = (item.position - get_node(player).position) * grid_scale + grid.rect_size / 2
		# If marker is outside grid, hide or shrink it.
		if grid.get_rect().has_point(obj_pos + grid.rect_position):
			markers[item].scale = Vector2(1, 1)
#			markers[item].show()
		else:
			markers[item].scale = Vector2(0.75, 0.75)
#			markers[item].hide()
		# Don't draw markers outside grid rectangle.
		obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
		markers[item].position = obj_pos
		
	
	
func _on_object_removed(object):
	# Removes a marker from the map. Connect to object's "removed" signal.
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)


func set_zoom(value):
	# Adjust zoom value and recalculate scale.
	zoom = clamp(value, 0.5, 5)
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	
	
func _on_MiniMap_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			self.zoom += 0.1
		if event.button_index == BUTTON_WHEEL_DOWN:
			self.zoom -= 0.1


