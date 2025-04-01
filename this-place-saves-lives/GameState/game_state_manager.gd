extends Node
class_name GameStateManager

func save_game():
	pass
	
func load_saved_game():
	pass

func initialize_game():
	# read in files: initial game state, initial character states
	load_game_state("res://GameState/init_session.cfg")
	
func start_game():
	get_tree().change_scene_to_file("res://Views/Main.tscn")


# -------------------------- utility functions ---------------------------------

func load_game_state(path: String):
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load(path)

	# If the file didn't load, ignore it.
	if err != OK:
		return

	Session.funds = config.get_value("MAIN", "initial_funds")
	Session.approval = config.get_value("MAIN", "initial_approval")
	
	Session.next_event_index = config.get_value("STORY", "next_event_index")
	Session.day = config.get_value("STORY", "day")
	
	var read_arr = config.get_value("STORY", "known_characters")
	for value in read_arr:
		if value is String:
			Session.known_characters.append(value)

	var read_dict = config.get_value("SERVICES", "max_per_service")
	for key in read_dict.keys():
		var service = Services.service_from_name(key)
		if service != -1:
			Session.max_per_service[service] = read_dict[key]
			
	read_dict = config.get_value("SERVICES", "unlocked_per_service")
	for key in read_dict.keys():
		var service = Services.service_from_name(key)
		if service != -1:
			Session.unlocked_per_service[service] = read_dict[key]
