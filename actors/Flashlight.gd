extends Light2D


onready var light_zone = $Area2D


func _physics_process(delta: float) -> void:
	for body in light_zone.get_overlapping_bodies():
		if body.is_in_group("enemy"):
			if self.visible:
				body.ai.flash_detected(get_parent())
