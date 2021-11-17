extends CanvasLayer


onready var current_ammo = $MarginContainer/Rows/BottomRow3/AmmoSection/CurrentAmmo
onready var max_ammo = $MarginContainer/Rows/BottomRow3/AmmoSection/MaxAmmo
onready var health_bar = $MarginContainer/Rows/BottomRow3/HealthSection/HealthBar
onready var house_bar = $HealthSection2/HouseBar
onready var health_tween = $MarginContainer/Rows/BottomRow3/HealthSection/HealthTween

var player: Player
var house: House

func set_player(player: Player,house: House):
	self.player = player
	self.house = house
	
	set_health(player.health_stat.health)
	set_current_ammo(player.weapon.current_ammo)
	set_max_ammo(player.weapon.max_ammo)
	set_house_bar(house.health_stat.health)
	
	player.connect("player_health_changed",self,"set_health")
	house.connect("base_health_changed",self,"set_house_bar")
	player.weapon.connect("weapon_ammo_changed",self,"set_current_ammo")
	# max ammo should set if we have more weapon for player
	
	
func set_health(new_health: int):
	health_tween.interpolate_property(health_bar, "value", health_bar.value,new_health,0.4,Tween.TRANS_LINEAR,Tween.EASE_IN)
	health_tween.start()
	 
func set_current_ammo(new_ammo: int):
	current_ammo.text = str(new_ammo)

func set_max_ammo(new_max_ammo: int):
	max_ammo.text = str(new_max_ammo)

func set_house_bar(new_health : int):
	health_tween.interpolate_property(house_bar, "value", house_bar.value,new_health,0.4,Tween.TRANS_LINEAR,Tween.EASE_IN)
	health_tween.start()
