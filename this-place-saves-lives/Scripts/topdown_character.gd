extends CharacterBody2D
class_name topdown_character

const default_skin = preload("res://Characters/placeholder_material.tres")
var room: Room

## The characterSetting ressource that defines this character (including appearance)
@export var character:CharacterSetting

var stateM: StateMachine
var current_needs: Array[CharacterSetting.Need]
var target: Vector2
var target_delta: Vector2

func _ready() -> void:
	#setup room ref
	room = get_parent()
	#make sure character is set up correctly
	if character != null:
		%Sprite.material = character.skin
	else: #TODO unnecessary in final game?
		%Sprite.material = default_skin
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
	#TODO set animation speed according to walking speed
	if self.velocity.length() > 1 and self.target_delta.abs() > Vector2.ONE:
		if abs(self.velocity.angle_to(Vector2.LEFT)) < PI/2:
			#TODO make this adaptive to body type in character_settings
			%Sprite.play("fem_walk_left",velocity.length()/GlobalSettings.animation_walking_speed_ps)
		else:
			%Sprite.play("fem_walk_right",velocity.length()/GlobalSettings.animation_walking_speed_ps)
	else:
		%Sprite.play("fem_default")

func _physics_process(_delta: float) -> void:
	self.move_and_slide()

func idle():
	if current_needs.is_empty():
		#character is done with all needs
		#set target to spawn point
		target = room.spawn_point.position
	else:
		# check current needs
		var next_need = current_needs.back()
		#request matching service+station
		var possible_targets = room.get_need_stations(next_need)
		if possible_targets.is_empty():
			#TODO remove need and give specific approval penalty
			SignalBus.approval_delta.emit(GlobalSettings.need_unfulfulled_penalty)
			current_needs.erase(next_need)
			print("Could not find a need so removing with penalty")
			return "Idle"
		
		possible_targets.sort_custom(
			func(a,b): \
			self.position.distance_to(a.global_position) \
			 < self.position.distance_to(b.global_position)
			)
		target = possible_targets.back().global_position
	return "Walking"
	
func walking():
	#set desired direction to follow route to service
	target_delta = target - position
	if target_delta.length() > GlobalSettings.navigation_precision:
		self.velocity = target_delta * (character.speed / target_delta.length())
	else: self.velocity = Vector2.ZERO
	#TODO check if station is still available?
	#		if no check aggression stat and initiate conflict if high
	#		else search for othersuitable station and reroute
	#TODO initiate fight on collision
	
func busy():
	pass
	#TODO check if timer for task is up and if yes transition to idle
	#TODO check if task specific events should be triggered
