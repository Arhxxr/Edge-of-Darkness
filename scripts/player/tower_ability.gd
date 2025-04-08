extends Node
class_name TowerAbility

@export var item : PackedScene  # Exported PackedScene variable for the tower item.

var previewItem: PlayerTower = null  # Variable to hold the preview of the tower item.

# Variables for handling mouse position in grid and world space.
var mouseToCell
var mouseToWorld
var gridSize

# Called when the node enters the scene tree for the first time.
func _init():
	# Initialize mouse position variables and grid size.
	mouseToCell = Grid.get_mouse_to_grid()
	mouseToWorld = Grid.get_mouse_to_grid(true)
	gridSize = Grid.get_cell_size()
	# Fetch the tower object from a centralized scene storage.
	item = PackedScenes.get_tower_object()

# Returns the center position of the grid cell under the mouse.
func getCenterGridPos():
	return Vector2(mouseToWorld.x + gridSize / 2, mouseToWorld.y + gridSize / 2)

# Creates an instance of the tower and positions it.
func createItem(tempItem: PackedScene):
	var _item = tempItem.instantiate()  # Instantiate the passed PackedScene.
	_item.position = getCenterGridPos()  # Set the position to the center of the grid cell.
	_item.set_z_index(mouseToCell.y)  # Set the z-index based on mouse position.
	
	get_tree().get_first_node_in_group("structures").add_child(_item)
	
	return _item  # Return the created item.

# Called every frame. Handles the preview and placement of the tower item.
func _process(delta):
	mouseToCell = Grid.get_mouse_to_grid()
	mouseToWorld = Grid.get_mouse_to_grid(true)
	# Check if the current state is TOWERABILITY.
	if GameManager.PlayerStates.TOWERABILITY == GameManager.PlayerState:
		# Create a preview item if it doesn't exist.
		if null == previewItem:
			previewItem = createItem(item)
			previewItem.changeState(previewItem.STATE.PREVIEW)
			previewItem.reparent(get_tree().get_first_node_in_group("previews"))
		else:
			# Update the position of the preview item.
			previewItem.position = getCenterGridPos()
			previewItem.set_z_index(mouseToCell.y)
			# Check if the tower can be placed.
			if Input.is_action_just_pressed("place_item") && previewItem.canPlace():
				var _item: PlayerTower = createItem(item)
				Grid.grid_cell_set_buildable(Grid.get_mouse_to_grid(), false, true)
				get_tree().call_group("enemies", "reset_target")
				_item.changeState(_item.STATE.BUILDING)
	else:
		# Free the preview item if it exists and the state is not TOWERABILITY.
		if previewItem != null:
			previewItem.queue_free()
