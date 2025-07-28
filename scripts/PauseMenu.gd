extends Control

func _ready():
	hide()
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key
		if not visible:
			pause_game()
		else:
			resume_game()

func pause_game():
	show()
	get_tree().paused = true

func resume_game():
	hide()
	get_tree().paused = false

func _on_resume_button_pressed():
	resume_game()

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn") 