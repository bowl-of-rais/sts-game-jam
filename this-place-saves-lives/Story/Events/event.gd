extends Node
class_name Event

@export var required_flags : Array[String]
@export var visited : bool = false

func _exit_tree():
	# update flags after scene here
	pass

func change_approval(val: int):
	SignalBus.approval_delta.emit(val)
	
func change_funds(val: int):
	SignalBus.funds_changed.emit(val)
