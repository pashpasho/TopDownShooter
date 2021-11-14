extends Position2D


onready var label = get_node("Label")
onready var tween = get_node("Tween")
var amount = 0

func _ready() -> void:
	label.set_text(str(amount))
	tween.interpolate_property(self,'scale',scale,Vector2(1,1),0.2,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	#tween.interpolate_property(self,Vector2(1,1),scale,Vector2(0.1,0.1),0.5,Tween.TRANS_LINEAR,Tween.EASE_OUT,0.3)
	tween.start()

func _on_Tween_tween_all_completed() -> void:
	self.queue_free()
