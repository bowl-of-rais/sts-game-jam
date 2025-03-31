extends Node

var character_base: PackedScene = preload("res://Characters/topdown_character.tscn")

var spawn_test_done = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not spawn_test_done:
		#test topdown character
		var test_character: topdown_character = character_base.instantiate()
		test_character.name = "test_character"
		test_character.character = load("res://Characters/test_character.tres")
		test_character.position = %Room.spawn_point.position
		
		%Room.add_child(test_character)
		spawn_test_done = true

func go_to_desk():
	%Room.hide()
	%Desk.show()
	
func go_to_room():
	#TODO maybe disable interaction boxes of desk/dialog if not already happening
	%Desk.hide()
	%Room.show()
