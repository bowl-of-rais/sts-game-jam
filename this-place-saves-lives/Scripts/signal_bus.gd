extends Node

signal approval_changed(new_approval, old_approval)
signal approval_delta(relative_approval)

# signal funds_changed(new_funds, old_funds)
signal funds_changed()

signal day_changed

signal service_full(type: Services.Types)

signal service_bought(type: Services.Types)

#sets up a new dialog event wen emitted
signal dialog_waiting(dialog_name)

#sets a dialog flag to a bool value
#story flags:
#	kitchen : if the community kitchen has been established
#	drugcheck: if the drugchecking service has been established
signal story_flag(flag_name:String, flag_value:bool)

#emitted when a story dialog starts
signal dialog_start

#emitted when a story dialog ends
signal dialog_end

signal log_event(description:String)

signal station_occupied(station:Station)
signal station_free(station:Station)

signal view_switch_desk()
signal view_switch_room()
