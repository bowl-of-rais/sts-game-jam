extends Node2D
class_name Room

@export var services: Array[ServiceManager]

## The spot where new characters should spawn
@onready var spawn_point: Marker2D = %SpawnPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func register_service(new: ServiceManager):
	if not services.has(new): services.append(new)
	
func unregister_service(old: ServiceManager):
	services.erase(old)

## get the services that fulfill a specific need
func get_need_stations(need : CharacterSetting.Need) -> Array[Station]:
	var results:Array[Station] = []
	for service in services:
		results.append_array(service.get_need_stations(need))
	return results

func _on_child_entered_tree(node: Node) -> void:
	if node is ServiceManager:
		register_service(node)

func _on_child_exiting_tree(node: Node) -> void:
	if node is ServiceManager:
		unregister_service(node)
