extends CharacterBody2D
class_name TopdownCharacter

const default_skin = preload("res://Characters/placeholder_material.tres")
var room: Room

## The characterSetting ressource that defines this character (including appearance)
@export var character:CharacterSetting

var stateM: StateMachine
var current_needs: Array[CharacterSetting.Need]
var target: Vector2
var target_delta: Vector2
var next_need: CharacterSetting.Need
var occupying_station: Station = null

func _ready() -> void:
	#setup room ref
	room = get_parent()
	#make sure character is set up correctly
	if character != null:
		#set skin
		%Sprite.material = character.skin
		#setup needs
		current_needs = character.initial_needs.duplicate()
	else: #TODO unnecessary in final game?
		%Sprite.material = default_skin
	
	#setup state machine
	stateM = StateMachine.new()
	stateM.add_state("Idle", idle)
	stateM.add_state("Walking", walking)
	stateM.add_state("Busy", busy, enter_busy)
	stateM.set_state("Idle") #set initial state

func _process(_delta: float) -> void:
	stateM.process()
	#set animation speed according to walking speed

func _physics_process(_delta: float) -> void:
	self.move_and_slide()

func idle():
	%Sprite.play("fem_default")
	if current_needs.is_empty():
		#character is done with all needs
		#set target to spawn point
		target = room.spawn_point.position
	else:
		# check current needs
		next_need = current_needs.back()
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
	# set correct animation
	if self.velocity.length() > 1 and self.target_delta.abs() > Vector2.ONE:
		if abs(self.velocity.angle_to(Vector2.LEFT)) < PI/2:
			#TODO make this adaptive to body type in character_settings
			%Sprite.play("fem_walk_left",self.velocity.length()/GlobalSettings.animation_walking_speed_ps)
		else:
			%Sprite.play("fem_walk_right",self.velocity.length()/GlobalSettings.animation_walking_speed_ps)
	#TODO check if station is still available?
	#		if no check aggression stat and initiate conflict if high
	#		else search for othersuitable station and reroute
	#TODO initiate fight on collision

func enter_busy():
	#stop character movement and targeting
	self.velocity = Vector2.ZERO
	self.target_delta = Vector2.ZERO
	match occupying_station.fulfills:
		CharacterSetting.Need.talk:
			SignalBus.dialog_waiting.emit(self.name)#use event name for dialog
			#switch view
			SignalBus.view_switch_desk.emit()
			SignalBus.dialog_end.connect(
				func():
					self.current_needs.erase(next_need)
					occupying_station.occupied = false
					occupying_station = null
					self.stateM.change_state("Idle")
					SignalBus.view_switch_room.emit()
					)
			return #stay in busy state
		_:#all other service interactions
			SignalBus.approval_delta.emit(GlobalSettings.need_fulfilled_reward)
			self.current_needs.erase(next_need)
			var timer = Timer.new()
			timer.one_shot = true
			timer.wait_time = GlobalSettings.service_busy_time_s
			timer.autostart = true
			timer.timeout.connect(
				func():
				self.stateM.change_state("Idle")
				occupying_station.occupied = false
				occupying_station = null
				)
			add_child(timer)

func busy():
	#TODO busy animation
	%Sprite.play("fem_default")
	#TODO animations (mb centering position on station)
	#TODO check if task specific events should be triggered

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.name == "DespawnArea" and current_needs.is_empty():
		#TODO some last game state changes before despawning
		room.character_left(character.name)
		#shedule this characters despawn
		self.queue_free()
		return
	
	var detected = area.get_parent()
	if detected is Station:
		#check if right station and set to busy
		var detected_station = detected as Station
		if detected_station.fulfills == next_need:
			detected_station.occupied = true
			occupying_station = detected_station
			stateM.change_state("Busy")
