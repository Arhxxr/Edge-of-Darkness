extends GatherResource

func add_resource(damage):
	if health > 0:
		Globals.add_wood_balance(damage)
