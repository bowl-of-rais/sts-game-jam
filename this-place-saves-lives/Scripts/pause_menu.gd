extends Control
class_name Pause

var active: bool = false

func _on_save_button_pressed() -> void:
	GlobalGameStateManager.save_game()

func _on_exit_button_pressed() -> void:
	GlobalGameStateManager.quit_game()

func _on_back_button_pressed() -> void:
	exit_menu()
	
func _input(event):
	if active and event.is_action_pressed("ui_cancel"):
		exit_menu()

func enter_menu():
	active = true
	%BackButton.disabled = false
	%SaveButton.disabled = false
	%ExitButton.disabled = false
	show()
	
func exit_menu():
	active = false
	%BackButton.disabled = true
	%SaveButton.disabled = true
	%ExitButton.disabled = true
	hide()
