extends VBoxContainer
class_name ShopItem

var service_type: Services.Types
var texture: Texture

var active: bool = true
var service_full = false
var price: int

func _ready() -> void:
	price = Services.price_of(service_type)
	%PriceTag.text = str(price)
	%ItemImage.texture = texture
	tooltip_text = Services.tooltip_text_of(service_type)
	SignalBus.service_full.connect(update_if_full)
	SignalBus.funds_changed.connect(update_in_budget)

func update_in_budget():
	var current_funds = Session.funds
	if current_funds < price:
		deactivate()
	else:
		if not service_full:
			activate()

func update_if_full(type: Services.Types):
	if type == service_type:
		service_full = true
		deactivate()

func deactivate() -> void:
	active = false
	%PriceTag.text = "!"
	%BuyButton.disabled = true
	
func activate() -> void:
	active = true
	%PriceTag.text = str(price)
	%BuyButton.disabled = false

func _on_buy_button_pressed() -> void:
	SignalBus.service_bought.emit(service_type)
