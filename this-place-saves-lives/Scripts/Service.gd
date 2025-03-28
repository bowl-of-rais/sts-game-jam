extends Node2D
class_name ServiceManager

@export var service_name: String
@export var stations: Array[Station]
var fullfills: Array[CharacterSetting.Need] #TODO is this needed?
@export var active:bool = false

func register_station(newNode:Node):
	if newNode is Station and not stations.has(newNode):
		stations.append(newNode)

func deregister_station(removedNode:Node):
	if removedNode is not Station: return #only handle stations here
	stations.erase(removedNode)

func update_need_fullfillment():#TODO currently not used
	for station in stations:
		if not fullfills.has(station.fullfills):
			fullfills.append(station.fullfills)

## gives the stations of this manager that fulfills
## the given need and is unoccupied
func get_need_stations(need: CharacterSetting.Need) -> Array[Station]:
	if active:
		return stations.filter(func(s:Station): return not s.occupied and s.fulfills==need)
	else: return []

func _ready() -> void:
	pass
