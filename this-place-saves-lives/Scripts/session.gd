extends Node

# --------------------------------- FUNDS --------------------------------------

var funds: int = 1000:
	get():
		return funds

# TODO: connect to signals?

func change_funds(val: int):
	# TODO: handle case where val < 0 && |val| > funds
	funds += val


# ------------------------------- SERVICES -------------------------------------



# -------------------------------- SAVING --------------------------------------

func save_game():
	pass
	
func load_game():
	pass
