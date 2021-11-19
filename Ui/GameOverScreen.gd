extends CanvasLayer


func _on_RestartButton_pressed():
	get_tree().change_scene("res://Main.tscn")

func _on_MainMenuButton2_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Ui/MainMenuScreen.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()


