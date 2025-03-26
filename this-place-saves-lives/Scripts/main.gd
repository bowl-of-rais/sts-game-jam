extends Node

#2 temporary test values
var emitted = false
var second = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#test one event
	if not emitted:
		SignalBus.dialog_waiting.emit("sam1")
		emitted = true
		#SignalBus.dialog_end.connect(next_dialog)

#add second dialog to test dialog deinitialization
func next_dialog():
	if not second:
		second = true
		SignalBus.dialog_waiting.emit("sarah2")
