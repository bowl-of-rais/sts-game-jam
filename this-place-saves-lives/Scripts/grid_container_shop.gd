extends GridContainer

func _ready():
	
	for serv in Services.Types.values():
		if serv != Services.Types.Reception:
			var item : ShopItem = load("res://UI/ShopItem.tscn").instantiate()
			item.service_type = serv
			item.texture = load(Services.texture_path_of(serv))

			add_child(item)
	
	print("All shop items created")
