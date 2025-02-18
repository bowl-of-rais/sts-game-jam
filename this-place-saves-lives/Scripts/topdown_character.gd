extends CharacterBody2D
class_name topdown_character

const default_skin = preload("res://Characters/placeholder_material.tres")

@export var character:CharacterSetting:
	set(new_settings):
		character = new_settings
		if character != null:
			%Sprite.material = character.skin
		else:
			%Sprite.material = default_skin
	get:
		return character

var stateM: StateMachine
var current_needs: Array[CharacterSetting.Need]
var desired_dir

func _ready() -> void:
	#setup character TODO make work in tool mode
	self.character = self.character
	#setup needs
	current_needs = character.initial_needs.duplicate()
	#setup state machine
	stateM = StateMachine.new()
	stateM.add_state("Idle", idle)
	stateM.set_state("Idle")
	stateM.add_state("Walking", walking)
	stateM.add_state("Busy", busy)

func _process(_delta: float) -> void:
	stateM.process()

func _physics_process(_delta: float) -> void:
	pass# move_and_slide towards walking target

func idle():
	pass
	#TODO check current needs
	#TODO request matching service+station
	#TODO calculate route
	#TODO transition to walking
	
func walking():
	pass
	#TODO set desired direction to follow route to service
	#TODO check if station is still available?
	#		if no check aggression stat and initiate conflict if high
	#		else search for othersuitable station and reroute
	#TODO initiate fight on collision
	
func busy():
	pass
	#TODO check if timer for task is up and if yes transition to idle
	#TODO check if task specific events should be triggered
