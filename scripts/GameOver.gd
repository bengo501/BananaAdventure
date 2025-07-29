extends Control

func _ready():
	hide()

func show_game_over():
	show()
	get_tree().paused = true

func _on_retry_button_pressed():
	hide()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn") 
