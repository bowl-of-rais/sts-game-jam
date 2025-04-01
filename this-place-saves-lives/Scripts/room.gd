extends Node2D
class_name Room

var services: Array[ServiceManager]
var characters_in_room: Array[String]

## The spot where new characters should spawn
@onready var spawn_point: Marker2D = %SpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	characters_in_room = []
	for child in get_children():
		if child is ServiceManager:
			register_service(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func register_service(new: ServiceManager):
	if new is not ServiceManager: return
	if not services.has(new): services.append(new)
	
func unregister_service(old: ServiceManager):
	if old is not ServiceManager: return
	services.erase(old)

## get the services that fulfill a specific need
func get_need_stations(need : CharacterSetting.Need) -> Array[Station]:
	var results:Array[Station] = []
	for service in services:
		results.append_array(service.get_need_stations(need))
	return results

func buy(type: Services.Types) -> bool:
	# iterate through children, find correct manager, acquire in manager
	for child in get_children():
		if child is ServiceManager:
			if child.type == type:
				child.unlock()
				return true
	return false
	
func check_capacities() -> void:
	for child in get_children():
		if child is ServiceManager:
			child.check_capacity()
			
func character_left(cname: String):
	characters_in_room.erase(cname)
