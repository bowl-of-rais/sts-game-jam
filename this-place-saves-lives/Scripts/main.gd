extends Node

var emitted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not emitted:
		SignalBus.dialog_waiting.emit("sarah1")
		emitted = true
