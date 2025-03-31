extends Node2D
class_name Station

@export var fulfills: CharacterSetting.Need

func _ready() -> void:
	%CollisionShape2D.disabled = true

var occupied: bool = true:
	get():
		return occupied
	set(new):
		#TODO hide, alternate look or sth
		occupied = new

var acquired: bool = false:
	get():
		return acquired

func acquire():
	acquired = true
	occupied = false
	visible = true
	%CollisionShape2D.disabled = false
