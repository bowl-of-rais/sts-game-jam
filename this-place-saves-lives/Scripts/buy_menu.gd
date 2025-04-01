extends Control

func _ready() -> void:
	SignalBus.service_bought.connect(buy)

func set_funds_display(val: int):
	%Label.text = str(val)

func _on_back_button_pressed() -> void:
	%Gui.show()
	hide()

func buy(type: Services.Types) -> void:
	var success = %Room.buy(type)
	
	if success:
		var price = Services.price_of(type)
		Session.change_funds(-price)
		Session.unlocked_per_service[type] += 1
		SignalBus.funds_changed.emit()
