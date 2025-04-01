extends Node

var character_base: PackedScene = preload("res://Characters/topdown_character.tscn")
#spawns a character when up
var spawn_timer: Timer
#determines how many known characters without dialogue are spawned in between story events
var non_story_spawn_count: int
var character_pool: Array[String]

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
	Session.next_event_index = 0
	non_story_spawn_count = 0
	character_pool = []
	#set up a timer that spawns characters
	spawn_timer = Timer.new()
	spawn_timer.wait_time = \
		randf_range(GlobalSettings.min_spawn_delay_s, GlobalSettings.max_spawn_delay_s)
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(
		func():
			spawn_timer.wait_time = \
				randf_range(GlobalSettings.min_spawn_delay_s, GlobalSettings.max_spawn_delay_s)
			next_spawn()
			)

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
	
func next_day():
	Session.next_day()
	%Day.update_day()
	
	%Day.visible = true
	get_tree().create_timer(1).timeout.connect(func(): %Day.visible = false)

func next_spawn():
	#TODO spawn non story characters in between
	if non_story_spawn_count == 0:
		spawn_character(StorySequence.event_order[Session.next_event_index])
		Session.next_event_index += 1
	else:
		spawn_character(character_pool.pick_random())
		non_story_spawn_count -= 1
		

func spawn_character(name:String):
	pass
	#test topdown character
	#var test_character: topdown_character = character_base.instantiate()
	#test_character.name = "Marel"
	#test_character.character = load("res://Characters/Marel1.tres")
	#test_character.position = %Room.spawn_point.position
	#%Room.add_child(test_character)
