extends Node

# --------------------------------- FUNDS --------------------------------------

var funds: int = 1000:
	get():
		return funds

func change_funds(val: int):
	# TODO: handle case where val < 0 && |val| > funds
	funds += val

var approval: int = 50:
	get():
		return approval

func change_approval(val: int):
	# TODO: handle case where val < 0 && |val| > funds
	approval += val

# ------------------------------- SERVICES -------------------------------------

var max_per_service: Dictionary[Services.Types, int]

var unlocked_stations: Dictionary[Services.Types, int]

# ------------------------------ CHARACTERS ------------------------------------

var characters: Dictionary[String, CharacterSetting]

var true_story_flags: Array[String]

# adds a flag to the set of globally tracked story flags
func add_story_flag(flag_name: String):
	true_story_flags.append(flag_name)

# for an array of story flags, checks if they are all true
func check_story_flags(flags: Array[String]) -> bool:
	for f in flags:
		if f not in true_story_flags:
			return false
	return true

# --------------------------------- STORY --------------------------------------

var next_event_index: int

# -------------------------------- SAVING --------------------------------------

func save_game():
	pass
	
func load_save_game():
	pass

func initialize_game():
	# read in files: initial game state, initial character states
	pass
