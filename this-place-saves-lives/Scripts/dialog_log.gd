extends Panel

@onready var log_text_label = get_node("PanelContainer/Log")

func _ready() -> void:
	SignalBus.log_event.connect(add_entry)

func toggle_log(visible:bool):
	self.visible = visible

##adds an event description in a new line of the log
func add_entry(event_description:String):
	log_text_label.text += event_description + "\n"
