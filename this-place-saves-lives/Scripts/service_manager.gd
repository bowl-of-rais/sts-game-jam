extends Node2D
class_name ServiceManager

# @export var service_name: String
var max_num: int
var stations: Array[Station]
var unlocked_stations: int = 0
@export var type : Services.Types
@export var active:bool = false

func register_station(newNode:Station):
	if newNode is Station and not stations.has(newNode):
		stations.append(newNode)

func deregister_station(removedNode:Station):
	if removedNode is not Station: return #only handle stations here
	stations.erase(removedNode)

## gives the stations of this manager that fulfills
## the given need and is unoccupied
func get_need_stations(need: CharacterSetting.Need) -> Array[Station]:
	if active:
		return stations.filter(func(s:Station): return not s.occupied and s.fulfills==need)
	else: return []

func _ready() -> void:
	max_num = Session.max_per_service[type]
	var should_be_unlocked = Session.unlocked_per_service[type]
	for child in get_children():
		register_station(child)
		if unlocked_stations < should_be_unlocked:
			unlock()
	if unlocked_stations == 0:
		visible = false

func unlock() -> bool:
	if unlocked_stations < max_num:
		stations[unlocked_stations].acquire()
		unlocked_stations += 1
		
		if not visible:
			visible = true
		
		check_capacity()
		return true
	return false

func check_capacity():
	if unlocked_stations >= max_num:
		SignalBus.service_full.emit(type)
