extends DramaDisplayControl

@onready var dialog_text_field = get_node("DialogPanel/DialogTextLabel")
@onready var dialog_box = get_node("DialogPanel")

@onready var player_text_field = get_node("PlayerPanel/PlayerTextLabel")
@onready var player_box = get_node("PlayerPanel")
@onready var speaker_name_label = get_node("DialogPanel/ActorName")

@onready var narration_box = get_node("NarrationPanel")
@onready var narration_text_field = get_node("NarrationPanel/NarrationTextLabel")

@onready var button_container = get_node("ChoiceButtonContainer")
##references the text field of the current speaker
@onready var speaker_text_field = null

var choice_button_template = preload("res://UI/CoiceButton.tscn")

var dialog_scene = null
var current_actor = null
var dialog_ready = false
var dialog_running = false
var choice_pending = false

func _ready() -> void:
	#connect to signal that indicates character waiting at desk
	SignalBus.dialog_waiting.connect(_on_dialog_waiting)
	%DramaPlayer.connect_display(self)

func _on_dialog_waiting(dialog_name):
	assert(not dialog_ready, "no dialog should be waiting before getting another ready")
	#load dialog scene instance
	var path: String = "res://Story/Events/" + dialog_name + ".tscn"
	dialog_scene = load(path).instantiate()
	add_child(dialog_scene)
	#load gdrama dialog
	%DramaPlayer.load_gdrama("res://Story/Dialog/" + dialog_name + ".gdrama")
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
			SignalBus.dialog_start.emit()
			%DramaPlayer.start_drama()
		
func remove_buttons():
	button_container.visible = false
	#disable every button in the container
	for button_container in button_container.get_children():
		button_container.queue_free()

##sets a dialog flag to be read in gdrama dialog
func set_flag(name:String, value:bool):
	assert(name is String and value is bool, "Flag can only be string and bool")
	assert(name != "", "Flag name can not be empty")
	%DramaPlayer.drama_reader.flags[name] = value

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
	SignalBus.log_event.emit(self.current_actor + " : " + raw_text)

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
	if choice_pending:
		return
	choice_pending = true
	button_container.visible = true
	player_box.visible = false
	narration_box.visible = false
	#make a button for every option
	for i in range(len(line.choices)):
		var current_button_container = choice_button_template.instantiate()
		var current_button = current_button_container.get_child(0)
		current_button.text = line.choices[i]
		current_button.pressed.connect(func chosei(): 
			self.drama_player.make_choice(i)
			remove_buttons()
			self.choice_pending = false
		)
		current_button.disabled = false
		button_container.add_child(current_button_container)

## Will be called to signal the current actor. Can be used, for instance, to
## display that actor's name and sprite
##
## Note that this is called before any functions related to text display, such
## as _set_raw_text and _spoke, so it may be used to determine which display
## to focus on out of many
func _set_actor(actor: String):
	current_actor = actor
	if actor.to_lower() == "player":
		current_actor = "You"
		speaker_text_field = player_text_field
		player_box.visible = true
		dialog_box.visible = false
		narration_box.visible = false
	elif actor == "":
		current_actor = "Narration"
		speaker_text_field = narration_text_field
		narration_box.visible = true
		player_box.visible = false
		dialog_box.visible = false
	else:
		speaker_name_label.text = actor
		speaker_text_field = dialog_text_field
		dialog_box.visible = true
		player_box.visible = false
		narration_box.visible = false

## Will be called to signal that the current scene has ended. Can be used, for
## instance, to close the current dialogue windows and free the player's
## movement
func _ended_drama(_info: String):
	#TODO do some fading out
	self.visible = false
	player_box.visible = false
	dialog_box.visible = false
	narration_box.visible = false
	#remove event scene (containing character sprite and mb other stuff)
	dialog_scene.queue_free()
	self.dialog_running = false
	SignalBus.dialog_end.emit()
	
## Will be emited when the GDrama calls for a function. Can be used to implement
## specific functions, such as changing a character's mood
func _drama_call(method_name: String, args: Array):
	if dialog_scene.has_method(method_name):
		dialog_scene.callv(method_name, args)
