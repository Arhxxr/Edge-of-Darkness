extends Node2D

@export var starting_level = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	update_grid()
	add_to_group("gem_collected")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(damage):
	# INSERT DAMAGE ANIMATION & SOUND EFFECTS FOR CAPITAL BUILDING GETTING HURT
	Globals.city_insanity += abs(damage)
	
	if Globals.city_insanity >= Globals.city_max_insanity:
		get_tree().change_scene_to_file("res://scenes/UI/game_over.tscn")



# Don't look, infohazard


func update_grid():
	# Set the buildable grids.
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position), false, false, false)
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(0.0, -1), false)
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(0, -2.0), false)
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(-1, -1), false)
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(-1, -2.0), false)
	
	# First stage light
	update_light(starting_level + Globals.gems_collected)

func update_light(level: int):
	light_area(Grid.get_world_to_grid(global_position) + Vector2(-1, -2) + Vector2(-level, -level), Grid.get_world_to_grid(global_position) + Vector2(0, -1) + Vector2(level, level))

func light_area(pos: Vector2, pos2: Vector2):
	for _x in range(pos.x, pos2.x + 1):
		for _y in range(pos.y, pos2.y + 1):
			# Clip top corners
			if (_x == pos.x && _y == pos.y || _x == pos2.x && _y == pos.y):
				continue
			# Clip bottom corners
			if (_x == pos.x && _y == pos2.y || _x == pos2.x && _y == pos2.y):
				continue
			Grid.grid_cell_set_buildable(Vector2(_x, _y))

func gem_collected():
	var gem_label = get_node('/root/Root/UI/GemAmount')	
	gem_label.text = str(Globals.gems_collected)
	update_light(starting_level + Globals.gems_collected)
