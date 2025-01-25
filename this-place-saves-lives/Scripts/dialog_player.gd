extends DramaDisplayControl

@onready var dialog_text_field = get_node("DialogPanel/DialogTextLabel")
@onready var dialog_box = get_node("DialogPanel")
@onready var answer_button1 = get_node("AnswerButton1")
@onready var answer_button2 = get_node("AnswerButton2")
@onready var player_text_field = get_node("PlayerPanel/PlayerTextLabel")
@onready var player_box = get_node("PlayerPanel")
@onready var speaker_text_field = dialog_text_field

var dialog_scene = null

var dialog_ready = false
var dialog_running = false

func _ready() -> void:
	#connect to signal that indicates character waiting at desk
	SignalBus.dialog_waiting.connect(_on_dialog_waiting)
	%DramaPlayer.connect_display(self)
	

func _on_dialog_waiting(dialog_name):
	assert(not dialog_ready, "no dialog should be waiting before getting another ready")
	#load dialog scene instance
	var path: String = "res://Events/" + dialog_name + ".tscn"
	add_child(await load(path).instantiate())
	dialog_scene = get_node("Dialog")
	#load gdrama dialog
	%DramaPlayer.load_gdrama("res://Dialog/" + dialog_name + ".gdrama")
	self.dialog_ready = true
	self.visible = true

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	 and event.button_index == 1 \
	 and event.pressed :
		#if the dialog player was left clicked:
		#advance dialog if more lines are available and no decision is pending
		if dialog_running:
			self.drama_player.next_or_skip()
		elif dialog_ready:
			self.dialog_ready = false
			self.dialog_running = true
			%DramaPlayer.start_drama()
		
func hide_and_disable_buttons():
	answer_button1.disabled = true
	answer_button1.visible = false
	answer_button2.disabled = true
	answer_button2.visible = false

# === DramaDisplay Overrides ===

## Will be called when the dialogue has been skipped. It can be used, for
## instance, for drawing all letters of the dialogue
func _skipped():
	speaker_text_field.visible_characters = len(speaker_text_field.text)

## Will be called when the current direction ends. It can be used, for instance,
## to add a visual indicator that the dialogue can be skipped
func _direction_ended():
	pass
	#TODO add indicator?

## Will be called to signal that the given text should be displayed in the main
## label. Can, for instance, set this text to a RichTextLabel and update its
## visible_characters property to 0
func _set_raw_text(raw_text: String):
	speaker_text_field.text = raw_text
	speaker_text_field.visible_characters = 0

## Will be called to signal that the given letter has been displayed. Can, for
## instance, add one to the visible_characters property of the RichTextLabel 
## that's displaying the main text and play a randomized sound
func _spoke(letter: String):
	speaker_text_field.visible_characters += 1
	#TODO talking sound?

## Will be emited when the GDrama expects a choice to be made. Should display
## the available options to the player and, once one has been chosen, pass that
## choice to the DramaPlayer through the make_choice() method
##
## Line will be of the form 
## {
## "type": "CHOICE", 
## "choices": ["Choice 1 text", "Choice 2 text", ...],
## "results": ["Choice 1 result", "Choice 2 result", ...],
## "conditions": [true, false, ...]
## }
func _ask_for_choice(line: Dictionary):
	#assuming only binary choices for now
	assert(len(line.choices) == 2)
	player_text_field.visible = false
	answer_button1.text = line.choices[0]
	answer_button1.pressed.connect(func chose0(): 
		self.drama_player.make_choice(0)
		hide_and_disable_buttons()
		)
	answer_button1.disabled = false
	answer_button1.visible = true
	answer_button2.text = line.choices[1]
	answer_button2.pressed.connect(func chose1(): 
		self.drama_player.make_choice(1)
		hide_and_disable_buttons()
		)
	answer_button2.disabled = false
	answer_button2.visible = true

## Will be called to signal the current actor. Can be used, for instance, to
## display that actor's name and sprite
##
## Note that this is called before any functions related to text display, such
## as _set_raw_text and _spoke, so it may be used to determine which display
## to focus on out of many
func _set_actor(actor: String):
	if actor.to_lower() == "player":
		speaker_text_field = player_text_field
		player_box.visible = true
		dialog_box.visible = false
	else:
		speaker_text_field = dialog_text_field
		dialog_box.visible = true
		player_box.visible = false

## Will be called to signal that the current scene has ended. Can be used, for
## instance, to close the current dialogue windows and free the player's
## movement
func _ended_drama(_info: String):
	self.dialog_running = false
	#remove event scene (containing character sprite and mb other stuff)
	self.visible = false
	#TODO do some fading out
	get_node("Dialog").queue_free()
	
## Will be emited when the GDrama calls for a function. Can be used to implement
## specific functions, such as changing a character's mood
func _drama_call(method_name: String, args: Array):
	if dialog_scene.has_method(method_name):
		dialog_scene.callv(method_name, args)
