extends Control
class_name GUI

func _on_shop_button_pressed() -> void:
	hide()
	%BuyMenu.show()

func set_funds_display(val: int):
	%Label.text = str(val)
