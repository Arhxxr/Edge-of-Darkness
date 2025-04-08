extends Node

# Preloaded PackedScene for the item.
var item : PackedScene

# Enumeration for different states.
enum STATE {BUILDING, THORHAND}
# Current state of the node, initially set to BUILDING.
var currentState = STATE.BUILDING
# A variable to hold a reference to a PlayerLight object, initially null.
var previewItem: PlayerLight = null

# Variables for handling mouse position conversions.
var mouseToCell
var mouseToWorld
var gridSize

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize mouseToCell, mouseToWorld, and gridSize using methods from the Grid class.
	mouseToCell = Grid.get_mouse_to_grid()
	mouseToWorld = Grid.get_mouse_to_grid(true)
	gridSize = Grid.get_cell_size()
	# Load the light object scene.
	item = PackedScenes.get_light_object()

# Returns the center position of the grid cell under the mouse.
func getCenterGridPos():
	return Vector2(mouseToWorld.x + gridSize / 2, mouseToWorld.y + gridSize / 2)

# Creates an instance of the given PackedScene and positions it in the center of the grid cell.
func createItem(tempItem: PackedScene):
	var _item = tempItem.instantiate()
	_item.position = getCenterGridPos()
	_item.set_z_index(mouseToCell.y)
	# Adds the instantiated item to the "structures" group in the scene tree.
	get_tree().get_first_node_in_group("lights").add_child(_item)

	return _item

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update mouse position variables each frame.
	mouseToCell = Grid.get_mouse_to_grid()
	mouseToWorld = Grid.get_mouse_to_grid(true)
	
	# Check if the current player state is LIGHTABILITY.
	if GameManager.PlayerStates.LIGHTABILITY == GameManager.PlayerState:
		if (null == previewItem):
			# Create a preview item if none exists.
			previewItem = createItem(item)
			previewItem.changeState(previewItem.STATE.PREVIEW)
			previewItem.reparent(get_tree().get_first_node_in_group("previews"))
		else:
			# Update the position of the preview item.
			previewItem.position = getCenterGridPos()
			previewItem.set_z_index(mouseToCell.y)
			# If the action to place the item is triggered, create a new item.
			if Input.is_action_just_pressed("place_item") && previewItem.canPlace():
				var _item: PlayerLight = createItem(item)
				_item.changeState(_item.STATE.BUILDING)
	else:
		# Free the preview item if it exists and the state is not LIGHTABILITY.
		if (null != previewItem):
			previewItem.queue_free()
