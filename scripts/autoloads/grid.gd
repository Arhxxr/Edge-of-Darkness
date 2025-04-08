extends Node2D

# The number of cells in the world
@onready var gridSize : Vector2 = Vector2(128, 128)
# The size of grid cells
@onready var gridCellSize = 64

# The position of the mouse.
@onready var mousePos = Vector2()
# The cell the mouse is currently over
@onready var mouseCell = get_mouse_to_grid()

@onready var buildable_cells: Dictionary = {}

func get_buildable_cells():
	return buildable_cells

func grid_cell_buildable(pos: Vector2):
	return buildable_cells.has(pos) && buildable_cells[pos]

func grid_cell_set_buildable(pos: Vector2, buildable: bool = true, force: bool = false, update_fog: bool = true):
	if (force):
		buildable_cells[pos] = buildable
	else:
		if !buildable_cells.has(pos):
			buildable_cells[pos] = buildable
	if update_fog:
		get_tree().call_group("fog", "update_fog", pos, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Get the position of the mouse in global coordinates
	mousePos = get_global_mouse_position()
	
	# Update mouseCell to be the current grid cell under the mouse
	mouseCell = get_mouse_to_grid()

# Returns the size of a single grid cell
func get_cell_size():
	return gridCellSize
	
# Converts the current mouse position to a grid position
# @param worldSpace: If true, returns position in pixels; if false, returns in grid units
func get_mouse_to_grid(worldSpace: bool = false):
	var _worldSpace = 1
	
	if (worldSpace):
		_worldSpace = gridCellSize

	# Calculate grid position. If worldSpace is true, multiplies by cell size.
	var gridPos = Vector2(floor(mousePos.x / gridCellSize) * _worldSpace, floor(mousePos.y / gridCellSize) * _worldSpace)
	return gridPos

# Converts the world position to a grid cell
func get_world_to_grid(pos: Vector2):
	# Calculate grid position.
	var gridPos = Vector2(floor(pos.x / gridCellSize), floor(pos.y / gridCellSize))
	return gridPos

# Converts the grid position to a world position
func get_grid_to_world(pos: Vector2, centered: bool = true):
	# Calculate grid position.
	var worldPos = Vector2(pos.x * gridCellSize, pos.y * gridCellSize)
	
	# Get center inside grid.
	if centered:
		worldPos += Vector2(gridCellSize/2, gridCellSize/2)
		
	return worldPos


# Returns the size of the world in pixels (gridSize multiplied by gridCellSize)
func get_world_size():
	return gridSize * gridCellSize
