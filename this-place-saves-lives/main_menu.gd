extends Node

func _ready() -> void:
	pass


func _on_play_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Views/DeskView.tscn")


func _on_settings_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MenuPages/SettingsPage.tscn")


func _on_about_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MenuPages/AboutPage.tscn")


func _on_c_ns_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MenuPages/CNsPage.tscn")
