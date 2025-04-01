extends Control
class_name Pause

func _on_save_button_pressed() -> void:
	GlobalGameStateManager.save_game()

func _on_exit_button_pressed() -> void:
	GlobalGameStateManager.quit_game()

func _on_back_button_pressed() -> void:
	hide()
