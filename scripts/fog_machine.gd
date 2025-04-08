class_name FogMachine
extends Sprite2D

# Preloads the light texture from a specified path in the project's resources.
const light_texture = preload("res://assets/art/sprites/light.png")

# Creates an Image from the light texture for manipulation.
var light_image = light_texture.get_image()
# Calculates the offset to center the light texture based on its dimensions.
var light_offset = Vector2(light_texture.get_width()/2, light_texture.get_height()/2)

# Initializes an Image for the fog effect.
var fog_image = Image.new()
# An ImageTexture to display the fog Image.
var fog_texture = ImageTexture.new()

# Exports a variable to the editor allowing adjustment of the light radius.
@export var light_radius = 3;

var fog_min = 0.026
var fog_current = 0.026
var fog_max = 0.2
var fog_change = 1
var fog_target = fog_max

@onready var grid_fog_timer: Dictionary = {}


func temporary_unfog(cell: Vector2, time = 0.2):
	var timer
	if grid_fog_timer.has(cell) && is_instance_valid(grid_fog_timer[cell]):
		timer = grid_fog_timer[cell]
		timer.start(time)
	else:
		if is_grid_fog(cell, false, 0.2) && Globals.game_running && !Globals.in_menu:
			timer = Timer_Deleter.new()
			update_fog(cell, false, 0.4)
			timer.connect("timeout", Callable(self, "restore_fog").bind(cell, false))
			timer.one_shot = true
			timer.wait_time = time
			get_tree().get_root().add_child(timer)
			timer.start()
			grid_fog_timer[cell] = timer

# Make the fog breath
func _process(delta):
	if (abs(fog_target - fog_current) >= 0.04):
		fog_current = lerp(fog_current, fog_target, fog_change * delta)
	else:
		if (fog_target == fog_min):
			fog_target = fog_max
		else:
			fog_target = fog_min
	
	material.set_shader_parameter('alpha_cutoff',fog_current)

# Updates the fog texture based on the given position.
func update_fog(pos: Vector2, world: bool = true, strength = 1):
	var _pos = abs(pos)
	var flag = false
	if (world):
		_pos = Grid.get_world_to_grid(pos)
	
	if (fog_image.get_pixelv(_pos).r > 0):
		flag = true
	# Defines a rectangle covering the entire light image3.
	var light_rect = Rect2i(_pos, Vector2(1, 1))
	# Blends the light image onto the fog image at the specified position, accounting for the light offset.
	fog_image.fill_rect(light_rect, Color(strength, 0, 0))
	# Updates the fog texture with the modified fog image.
	fog_texture = ImageTexture.create_from_image(fog_image)
	# Sets the Sprite2D's texture to the updated fog texture.
	
	texture = fog_texture
	texture.set_size_override(Vector2i(Grid.gridSize.x * Grid.gridCellSize, Grid.gridSize.y * Grid.gridCellSize))

	return flag

# Updates the fog texture based on the given position.
func restore_fog(pos: Vector2, world: bool = true):
	var _pos = pos
	if (world):
		_pos = Grid.get_world_to_grid(pos)
	
	
	if (!is_grid_fog(_pos, false, 1)):
		return

	# Defines a rectangle covering the entire light image.
	var light_rect = Rect2i(_pos, Vector2(1, 1))
	# Blends the light image onto the fog image at the specified position, accounting for the light offset.
	fog_image.fill_rect(light_rect, Color.BLACK)
	# Updates the fog texture with the modified fog image.
	fog_texture = ImageTexture.create_from_image(fog_image)
	# Sets the Sprite2D's texture to the updated fog texture.
	
	texture = fog_texture
	texture.set_size_override(Vector2i(Grid.gridSize.x * Grid.gridCellSize, Grid.gridSize.y * Grid.gridCellSize))

func is_grid_fog(pos, world: bool = true, cutoff = 1):
	#abs fixes bug where mouse goes off screen
	var _pos = abs(pos)
	if (world):
		_pos = Grid.get_world_to_grid(pos)

	return fog_image.get_pixelv(_pos).r < cutoff

# Called when the node enters the scene tree for the first time.
func _ready():
	# Creates a new Image for the fog with the size based on the grid size and cell size, sets format for alpha support.
	fog_image = Image.create(Grid.gridSize.x, Grid.gridSize.y, false, Image.FORMAT_RGBAH)
	# Fills the fog image with black color.
	fog_image.fill(Color.BLACK)
	# Converts the light image to a format with alpha support and resizes it.
	# Creates a texture from the fog image and sets it as the sprite's texture.
	fog_texture = ImageTexture.create_from_image(fog_image)
	texture = fog_texture
