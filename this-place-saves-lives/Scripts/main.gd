extends Node

var character_base: PackedScene = preload("res://Characters/topdown_character.tscn")
#spawns a character when up
var spawn_timer: Timer
#determines how many known characters without dialogue are spawned in between story events
var non_story_spawn_count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect signals to UI
	SignalBus.view_switch_desk.connect(go_to_desk)
	SignalBus.view_switch_room.connect(go_to_room)
	SignalBus.funds_changed.connect(update_funds_display)
	update_funds_display()
	%Room.check_capacities()
	SignalBus.approval_delta.connect(update_approval)
	#Initialize story at the beginning TODO do this dependant on save data
	Session.next_event = 0
	non_story_spawn_count = 0
	#set up a timer that spawns characters
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1.0
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(
		func():
			spawn_timer.wait_time = \
				randf_range(GlobalSettings.min_spawn_delay_s, GlobalSettings.max_spawn_delay_s)
			next_spawn()
			)
	add_child(spawn_timer)
	SignalBus.dialog_start.connect(func():spawn_timer.paused = true)
	SignalBus.dialog_end.connect(func():spawn_timer.paused = false)
	SignalBus.dialog_end.connect(on_dialog_end)
	show_day()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
		

func go_to_desk():
	%Room.hide()
	%Desk.show()
	
func go_to_room():
	#TODO maybe disable interaction boxes of desk/dialog if not already happening
	%Desk.hide()
	%Room.show()

func update_funds_display():
	var new_funds = Session.funds
	%BuyMenu.set_funds_display(new_funds)
	%Gui.set_funds_display(new_funds)
	
func update_approval(val: int):
	Session.change_approval(val)
	var new_approval = Session.approval
	%Gui.set_approval_display(new_approval)
	
func start_next_day():
	Session.next_day()
	show_day()
	
func show_day():
	%Day.visible = true
	get_tree().create_timer(3).timeout.connect(func(): %Day.visible = false)

## Checks if number of events per day is reached, activates Day scene if yes
func on_dialog_end():
	if Session.next_event == StorySequence.event_order.size():
		demo_end()
	if Session.next_event % Session.events_per_day == 0:
		start_next_day()

func demo_end():
	get_tree().change_scene_to_file("res://Views/EndOfDemo.tscn")

func next_spawn():
	#spawn non story characters in between
	var chara_name :String
	var setting :CharacterSetting
	assert(non_story_spawn_count >= 0, "non_story_spawn_count should never be less than 0!")
	if non_story_spawn_count == 0 and Session.next_event < StorySequence.event_order.size():
		chara_name = StorySequence.event_order[Session.next_event]
		setting = load("res://Characters/" + chara_name + ".tres")
		#TODO add characters once event is over
		Session.known_characters.append_array(StorySequence.event_characters[chara_name])
		Session.next_event += 1
		non_story_spawn_count = \
		randi_range(GlobalSettings.min_non_story_spawn, GlobalSettings.max_non_story_spawn)
	else:
		var available_characters = \
		Session.known_characters.filter(func(cn:String): return %Room.characters_in_room.count(cn)==0)
		if available_characters.is_empty():
			print("Spawn skipped due to no available characters!")
			return
		chara_name = available_characters.pick_random()
		setting = Session.characters[chara_name]
		if non_story_spawn_count > 0: non_story_spawn_count -= 1
	spawn_character(chara_name, setting)

func spawn_character(chara_name:String, setting: CharacterSetting):
	#test topdown character
	#var test_character: topdown_character = character_base.instantiate()
	var new_character:TopdownCharacter = character_base.instantiate()
	#set node name to event name or generic character name
	new_character.name = chara_name
	#set event settings or generic settings
	new_character.character = setting
	%Room.characters_in_room.append(setting.name)
	#set character on spawn position
	new_character.position = %Room.spawn_point.position
	#add character to room (enables processing)
	%Room.add_child(new_character)
