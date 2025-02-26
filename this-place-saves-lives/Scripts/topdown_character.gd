extends CharacterBody2D
class_name topdown_character

const default_skin = preload("res://Characters/placeholder_material.tres")
var spawn_point: Node2D #set to spawn point marker when spawned
var room: Room

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
var target: Vector2

func _ready() -> void:
	#setup character TODO make work in tool mode
	self.character = self.character
	#setup needs
	current_needs = character.initial_needs.duplicate()
	#setup state machine
	stateM = StateMachine.new()
	stateM.add_state("Idle", idle)
	stateM.add_state("Walking", walking)
	stateM.add_state("Busy", busy)
	stateM.set_state("Idle") #set initial state

func _process(_delta: float) -> void:
	stateM.process()

func _physics_process(_delta: float) -> void:
	pass# move_and_slide towards walking target

func idle():
	if current_needs.is_empty():
		#character is done with all needs
		#set target to spawn point
		target = spawn_point.position
	else:
		# check current needs
		var next_need = current_needs.back()
		#request matching service+station
		var possible_targets = room.get_need_stations(next_need)
		possible_targets.sort_custom(
			func(a,b):self.position.distance_to(a.position) < self.position.distance_to(b.position)
			)
		target = possible_targets.back().position
		return "Walking"
	
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
