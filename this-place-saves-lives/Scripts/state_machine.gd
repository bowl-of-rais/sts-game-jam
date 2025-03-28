extends Object
class_name StateMachine

class State:
	var name: StringName
	var enter_callback:Callable
	var active_callback:Callable
	var exit_callback:Callable
	
	func _init(sname:StringName, enter:Callable, active:Callable, exit:Callable):
		self.name = sname
		self.enter_callback = enter
		self.active_callback = active
		self.exit_callback = exit

signal state_changed(new_state_name: StringName)
var current_state: State
var states: Dictionary

func _init():
	current_state = null
	states = {}

## adds a new state by name and returns if it was successful
func add_state(state_name: StringName, active_callback:Callable,
				 enter_callback=func():pass, exit_callback=func():pass):
	if states.has(state_name):
		printerr("State " + state_name + " already defined!")
		return false
	states[state_name] = State.new(state_name, enter_callback, active_callback, exit_callback)
	return true
	
func edit_state(state_name: StringName, active=null, enter=null, exit=null):
	if not states.has(state_name):
		printerr("No state named "+ state_name + " in this StateMachine!")
		return false
	if active is Callable:
		states[state_name].active_callback = active
	if enter is Callable:
		states[state_name].enter_callback = enter
	if exit is Callable:
		states[state_name].exit_callback = exit
	return true

##removes a state by name and returns if it was succesfull
func remove_state(state_name: StringName):
	if not states.has(state_name): return false
	states.erase(state_name)
	return true

##to change the state on a running state machine (makes transitions)
func change_state(state_name: StringName):
	assert(self.current_state != null)
	if not states.has(state_name):
		printerr("State " + state_name + " not found in this StateMachine!")
		return false
	self.current_state.exit_callback.call()
	self.current_state = states[state_name]
	self.current_state.enter_callback.call()
	return true

##set the current state manually (no transitions)
func set_state(state_name: StringName):
	assert(states.has(state_name))
	self.current_state = states[state_name]

##processes the current state and does state transitions if necessary
func process():
	if current_state == null or states.is_empty():
		printerr("StateMachine has no defined states yet!")
		return
	
	var next_state_name = self.current_state.active_callback.call()
	#in case of requested state change
	if next_state_name != null and next_state_name != current_state.name:
		self.current_state.exit_callback.call()
		var state_candidate = states.get(next_state_name)
		#in case of unknown state transition to current state again
		if state_candidate == null:
			printerr("Could not find state " + next_state_name)
			state_candidate = self.current_state
		#set new state and notify it about being active
		self.current_state = state_candidate
		self.current_state.enter_callback.call()
		state_changed.emit(self.current_state.name)
