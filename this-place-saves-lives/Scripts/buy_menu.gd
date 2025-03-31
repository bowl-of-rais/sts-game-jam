extends Control

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
		SignalBus.funds_changed.emit()


func _on_buy_cons_table_button_pressed() -> void:
	buy(Services.Types.Consumption)


func _on_buy_toilet_button_pressed() -> void:
	buy(Services.Types.Toilet)


func _on_buy_tampons_button_pressed() -> void:
	buy(Services.Types.Menstrual)


func _on_buy_couch_button_pressed() -> void:
	buy(Services.Types.Couch)


func _on_buy_microwave_button_pressed() -> void:
	buy(Services.Types.Kitchen)


func _on_buy_privacy_screen_button_pressed() -> void:
	buy(Services.Types.PrivacyScreen)


func _on_buy_lounge_table_button_pressed() -> void:
	buy(Services.Types.Lounge)


func _on_buy_shower_button_pressed() -> void:
	buy(Services.Types.Shower)
