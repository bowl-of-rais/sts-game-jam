extends Node2D
class_name Station

@export var fullfills: CharacterSetting.Need

var occupied: bool = false:
	get():
		return occupied
	set(new):
		#TODO hide or sth
		occupied = new
