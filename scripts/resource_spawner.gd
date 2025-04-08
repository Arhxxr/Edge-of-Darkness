class_name ResourceSpawner
extends Node2D

@export var rock: PackedScene
@export var big_rock: PackedScene
@export var wood: PackedScene
@export var gem: PackedScene
# Initializes an Image for the resource effect.
var resource = FastNoiseLite.new()

var generated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	resource.seed = randi()
	resource.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC
	resource.frequency = 1

func generate_resources():
	generated = true
	# Loop through grid and spawn rocks / wood
	for x in Grid.gridSize.x:
		for y in Grid.gridSize.y:
			var _value = resource.get_noise_2d(x, y)

			if (_value > 0 && _value <= 0.02):
				var _wood = wood.instantiate()
				_wood.position = Grid.get_grid_to_world(Vector2(x, y))
				add_child(_wood)
				Grid.grid_cell_set_buildable(Vector2(x,y), false, false, false)
				
			if (_value < 0 && _value >= -0.0050):
				var _rock = rock.instantiate()
				_rock.position = Grid.get_grid_to_world(Vector2(x, y))
				add_child(_rock)
				Grid.grid_cell_set_buildable(Vector2(x,y), false, false, false)
			
			if (_value < -0.0050 && _value >= -0.01):
				var _rock = big_rock.instantiate()
				_rock.position = Grid.get_grid_to_world(Vector2(x, y))
				add_child(_rock)
				Grid.grid_cell_set_buildable(Vector2(x,y), false, false, false)
				
			if (_value < -0.03 && _value >= -0.0308):
				var gems = get_tree().get_nodes_in_group("gems")
				if gems.size() < 30 * (7 - Globals.game_diffculty):
					var _rock = gem.instantiate()
					_rock.position = Grid.get_grid_to_world(Vector2(x, y))
					add_child(_rock)
					Grid.grid_cell_set_buildable(Vector2(x,y), false, false, false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!generated && get_tree().get_first_node_in_group("fog") != null):
		generate_resources()

