extends Control

@onready var dialog_text_field = get_node("DialogPanel/DialogTextLabel")
@onready var answer_button = get_node("AnswerButton")

func _ready() -> void:
	#connect to signal that indicates character waiting at desk
	SignalBus.dialog_waiting.connect(_on_dialog_waiting)

func _on_dialog_waiting(dialog_name):
	#load dialog scene instance
	var path: String = "res://Events/" + dialog_name + ".tscn"
	add_child(await load(path).instantiate())
	#load dialog text
	#json ressource in dialog scene or dialog tree

func _on_answer_pressed():
	pass

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	 and event.button_index == 0 \
	 and event.pressed :
		#if the dialog player was left clicked:
		#advance dialog if more lines are available and no decision is pending
		pass
