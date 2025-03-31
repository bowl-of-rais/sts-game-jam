extends Node2D
class_name ServiceManager

@export var service_name: String
@export var max_num: int
var stations: Array[Station]
var acquired_stations: int
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
	for child in get_children():
		register_station(child)

func buy() -> bool:
	if acquired_stations < max_num:
		stations[acquired_stations].acquire()
		acquired_stations += 1
		
		if acquired_stations == max_num:
			SignalBus.service_full.emit(type)
		return true
	return false
	
