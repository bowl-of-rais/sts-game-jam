extends Node2D
class_name Station

@export var fulfills: CharacterSetting.Need

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
