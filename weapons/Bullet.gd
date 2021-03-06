extends Area2D

class_name Bullet

export (int) var speed = 20

onready var kill_timer = $KillTimer

var direction = Vector2.ZERO
var team: int = -1

func _ready():
	kill_timer.start()

func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction*speed
		
		global_position += velocity

func set_direction(direction):
	self.direction = direction
	rotation = direction.angle()


func _on_KillTimer_timeout():
	queue_free()


func _on_Bullet_body_entered(body: Node) -> void:
	if body.has_method("handle_hit"):
		if body.has_method("get_team") and body.get_team() != team:
			body.handle_hit()
	queue_free()


func _on_Bullet_area_entered(area: Area2D) -> void:
	if area.has_method("handle_hit"):
		if area.has_method("get_team") and area.get_team() != team:
			area.handle_hit()
