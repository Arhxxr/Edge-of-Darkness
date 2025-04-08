extends Node2D

# The color of grid lines normally
@export var lineColor : Color = Color.DARK_CYAN
# The color of grid lines when hovered
@export var lineColorHighlight : Color = Color.CYAN

# The color of grid lines when hovered
@export var colorBuildable : Color = Color.GREEN
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Must call this to redraw the grid every frame.
	queue_redraw()

func _draw():
	# Get the world size
	var worldSize = Grid.get_world_size();
	for x in Grid.gridSize.x:
		# Calculate current X line position
		var xPos = x * Grid.gridCellSize
		# Draw line
		draw_line(Vector2(xPos, 0), Vector2(xPos, worldSize.y), lineColor)
	for y in Grid.gridSize.y:
		# Calculate current Y line position
		var yPos = y * Grid.gridCellSize
		# Draw line
		draw_line(Vector2(0, yPos), Vector2(worldSize.x, yPos), lineColor)
	
	# Highlight hovered cell
	var hoveredPos = Grid.get_mouse_to_grid(true)
	var hoveredRect = Rect2(hoveredPos.x, hoveredPos.y, Grid.gridCellSize, Grid.gridCellSize)
	draw_rect(hoveredRect, lineColorHighlight, true)
	
	if (GameManager.PlayerStates.TOWERABILITY == GameManager.PlayerState):
		for gridCell in Grid.get_buildable_cells():
			if Grid.grid_cell_buildable(gridCell):
				var buildRect = Rect2(gridCell.x * Grid.gridCellSize, gridCell.y * Grid.gridCellSize, Grid.gridCellSize, Grid.gridCellSize)
				draw_rect(buildRect, colorBuildable, true)
	
	if (GameManager.PlayerStates.LIGHTABILITY == GameManager.PlayerState):
		z_index = 100
	else:
		z_index = 20
