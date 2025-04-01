extends Node

func _ready() -> void:
	pass

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
