extends Node

func _ready() -> void:
	if GlobalGameStateManager.save_exists():
		%ContinueButton.disabled = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_continue_button_pressed() -> void:
	GlobalGameStateManager.load_saved_game()
	GlobalGameStateManager.start_game()

func _on_new_game_button_pressed() -> void:
	GlobalGameStateManager.initialize_game()
	GlobalGameStateManager.start_game()

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MenuPages/SettingsPage.tscn")


func _on_about_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MenuPages/AboutPage.tscn")


func _on_c_ns_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MenuPages/CNsPage.tscn")
