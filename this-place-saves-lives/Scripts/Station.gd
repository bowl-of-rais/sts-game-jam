extends Node2D
class_name Station

@export var fulfills: CharacterSetting.Need

var occupied: bool = false:
	get():
		return occupied
	set(new):
		#TODO hide, alternate look or sth
		occupied = new
