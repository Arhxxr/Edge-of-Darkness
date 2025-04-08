class_name EnemySpawner
extends Node2D

@export var enemy1: PackedScene
@export var enemy2: PackedScene
@export var enemy3: PackedScene

# Initializes an Image for the resource effect.
var resource = FastNoiseLite.new()

var generated: bool = false

var fog: FogMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	fog = get_tree().get_first_node_in_group("fog")
	resource.frequency = 1
	resource.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC

func generate_enemies(wave: bool = false):
	resource.seed = randi()
	generated = true
	# Loop through grid and spawn rocks / wood
	for x in Grid.gridSize.x:
		for y in Grid.gridSize.y:
			var _value = resource.get_noise_2d(x, y)
			
			if fog.is_grid_fog(Vector2(x, y)):
				if (_value > 0 && _value <= 0.005):
					var _enemy: Enemy = enemy1.instantiate()
					_enemy.position = Grid.get_grid_to_world(Vector2(x, y))
					add_child(_enemy)
					if (wave):
						_enemy.change_state(Enemy.STATE.AGGRO)

				if (_value < 0 && _value >= -0.005):
					var _enemy: Enemy = enemy2.instantiate()
					_enemy.position = Grid.get_grid_to_world(Vector2(x, y))
					add_child(_enemy)
					if (wave):
						_enemy.change_state(Enemy.STATE.AGGRO)

func generate_wave():
	var base = get_tree().get_first_node_in_group("base")
	for i in 10 + (5 * Globals.current_wave):
		var _pos = random_on_sphere(20 * Grid.get_cell_size())
		_pos = base.global_position + _pos
		if fog.is_grid_fog(Vector2(_pos.x, _pos.y)):
			var _enemy: Enemy = enemy1.instantiate()
			_enemy.position = _pos
			add_child(_enemy)
			_enemy.change_state(Enemy.STATE.AGGRO)
		else:
			i -= 1

func random_on_sphere(radius : float):
	# Generate random spherical coordinates
	var theta = 2 * PI * randf()
	var phi = PI * randf()

	# Convert to cartesian
	var x = sin(phi) * cos(theta) * radius
	var y = sin(phi) * sin(theta) * radius	

	return Vector2(x,y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!generated && get_tree().get_first_node_in_group("fog") != null):
		generate_enemies()

