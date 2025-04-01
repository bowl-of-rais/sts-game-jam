extends Node
class_name GameStateManager

const SAVED_SESSION_PATH = "user://saved_session.cfg"
const SAVED_CHARAS_PATH = "user://saved_characters.cfg"
const INIT_SESSION_PATH = "res://GameState/init_session.cfg"
const INIT_CHARAS_PATH = "res://GameState/init_characters.cfg"


const CHARAS_MATERIALS_PATH = "res://Characters/"

func save_game():
	save_game_state(SAVED_SESSION_PATH)
	save_character_states(SAVED_CHARAS_PATH)
	
func load_saved_game():
	load_game_state(SAVED_SESSION_PATH)
	load_character_states(SAVED_CHARAS_PATH)

func initialize_game():
	# read in files: initial game state, initial character states
	load_game_state(INIT_SESSION_PATH)
	load_character_states(INIT_CHARAS_PATH)
	
func start_game():
	get_tree().change_scene_to_file("res://Views/Main.tscn")

func quit_game():
	get_tree().change_scene_to_file("res://MainMenu.tscn")

# --------------------------- about save files ---------------------------------

func save_exists():
	return FileAccess.file_exists("user://saved_session.cfg")

# -------------------------- utility functions ---------------------------------

func load_game_state(path: String):
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load(path)

	# If the file didn't load, ignore it.
	if err != OK:
		return

	Session.funds = config.get_value("MAIN", "funds")
	Session.approval = config.get_value("MAIN", "approval")
	
	Session.next_event = config.get_value("STORY", "next_event")
	Session.current_day = config.get_value("STORY", "current_day")
	Session.known_characters = config.get_value("STORY", "known_characters")
	
	Session.max_per_service = config.get_value("SERVICES", "max_per_service")
	Session.unlocked_per_service = config.get_value("SERVICES", "unlocked_per_service")


func save_game_state(path: String):
	var config = ConfigFile.new()

	config.set_value("MAIN", "funds", Session.funds)
	config.set_value("MAIN", "approval", Session.approval)
	
	config.set_value("STORY", "next_event", Session.next_event)
	config.set_value("STORY", "current_day", Session.current_day)
	config.set_value("STORY", "known_characters", Session.known_characters)

	config.set_value("SERVICES", "max_per_service", Session.max_per_service)
	config.set_value("SERVICES", "unlocked_per_service", Session.unlocked_per_service)

	var err = config.save(path)


func load_character_states(path: String):
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load(path)

	# If the file didn't load, ignore it.
	if err != OK:
		return

	for character in config.get_sections():
		var char_res: CharacterSetting = CharacterSetting.new()
		char_res.name = config.get_value(character, "name")
		char_res.bodytype = config.get_value(character, "bodytype")
		char_res.overdose_risk = config.get_value(character, "overdose_risk")
		char_res.initial_needs = config.get_value(character, "needs")
		
		var skin_path = "/".join([CHARAS_MATERIALS_PATH, char_res.name + "_material.tres"])
		char_res.skin = load(skin_path)
		
		char_res.speed = config.get_value(character, "speed")
		
		Session.characters[char_res.name] = char_res
		

func save_character_states(path: String):
	var config = ConfigFile.new()

	for character in Session.characters.values():
		if character is CharacterSetting:
			var char_name = character.name
			config.set_value(char_name,"name", char_name)
			config.set_value(char_name, "bodytype", character.bodytype)
			config.set_value(char_name, "overdose_risk", character.overdose_risk)
			config.set_value(char_name, "needs", character.initial_needs)
			config.set_value(char_name, "speed", character.speed)

	var err = config.save(path)
