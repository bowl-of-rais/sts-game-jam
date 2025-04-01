extends Control

var active: bool = false

func _ready() -> void:
	SignalBus.service_bought.connect(buy)

func set_funds_display(val: int):
	%Label.text = str(val)

func _input(event):
	if not %PauseMenu.active and event.is_action_pressed("ui_cancel"):
		%PauseMenu.enter_menu()
		
func _on_back_button_pressed() -> void:
	exit_menu()

func exit_menu() -> void:
	%Gui.show()
	hide()
	active = false
	
func enter_menu() -> void:
	%Gui.hide()
	show()
	active = true

func buy(type: Services.Types) -> void:
	var success = %Room.buy(type)
	
	if success:
		var price = Services.price_of(type)
		Session.change_funds(-price)
		Session.unlocked_per_service[type] += 1
		SignalBus.funds_changed.emit()
