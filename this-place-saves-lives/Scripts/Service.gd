@tool
extends Node2D
class_name ServiceManager

@export var service_name: StringName
var stations: Array[Station]
var fullfills: Array[CharacterSetting.Need]

func register_station(newNode:Node):
	if newNode is Station and not stations.has(newNode):
		stations.append(newNode)

func deregister_station(removedNode:Node):
	if removedNode is not Station: return #only handle stations here
	stations.erase(removedNode)

func update_need_fullfillment():
	for station in stations:
		if not fullfills.has(station.fullfills):
			fullfills.append(station.fullfills)

func _ready() -> void:
	self.child_entered_tree.connect(register_station)
	self.child_exiting_tree.connect(deregister_station)
