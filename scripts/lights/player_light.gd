class_name PlayerLight
extends Node2D

@export var activeNode: Node2D

signal light_placed
# Scructure health.
enum STATE {DISABLED, BUILDING, BUILT, DESTROYED, PREVIEW}
@export var currentState: STATE = STATE.DISABLED
var maxHealth = 100
var health = maxHealth
var buildTime = 0.1
var buildProgress = 0
var buildSpeed = 10
var canBuild = false
var isBlocked = false

@export var wood_cost = 5
@export var rock_cost = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if (STATE.BUILT != currentState && null != activeNode):
		activeNode.hide()
	pass # Replace with function body.
	
func canPlace():
	var fog: FogMachine = get_tree().get_first_node_in_group("fog")
	var flag = true
	if (fog.has_method("is_grid_fog")):

		flag = fog.is_grid_fog(global_position)

	return (
			flag &&
			Globals.get_rock_balance() >= rock_cost &&
			Globals.get_wood_balance() >= wood_cost
		)

func setCanPlace(place: bool):
	canBuild = place

func getState():
	return currentState

func changeState(state: STATE):
	var lastState = currentState
	currentState = state
	
	if STATE.BUILDING == currentState:
		Globals.minus_wood_balance(wood_cost)
		Globals.minus_rock_balance(rock_cost)
	
	if (null != activeNode):
		if (STATE.BUILT == currentState):
			get_tree().call_group("fog", "update_fog", global_position)
			update_grid()
			
			activeNode.show()
		else:
			activeNode.hide()

func buildStep(delta):
	# Exit if not in building state.
	if (STATE.BUILDING != currentState):
		return
	
	# Force redraw of health bar
	queue_redraw()
	
	if (buildProgress < buildTime):
		buildProgress += buildSpeed * delta
	
	if (buildProgress >= buildTime):
		buildProgress = buildTime
		changeState(STATE.BUILT)
		light_placed.emit()

func builtStep(delta):
	# Exit if not in built state.
	if (STATE.BUILT != currentState):
		return

# Damage structure, destroy scructure if health at or below 0
func takeDamage(damage):
	# Force redraw for health bar 
	queue_redraw()
	# Force value to hurt, never heal from takeDamage
	health += abs(damage) * -1
	
	if (0 >= health):
		health = 0
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Find which state the structure is in.
	match currentState:
		STATE.BUILDING:
			buildStep(delta)
		STATE.BUILT:
			builtStep(delta)





# Don't look infohazard



func update_grid():
	# Set the buildable grids.
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position), false, true)
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(-1.0, 0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(-2.0, 0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(1.0, 0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(2.0, 0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(0, 1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(0, 2.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(0, -1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(0, -2.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(0, -1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(-1, -1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(1, 1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(-1, 1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(1, -1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(2, -1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(-2, -1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(2, 1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(-2, 1.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(1, -2.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(-1, -2.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(1, 2.0))
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position) + Vector2(-1, 2.0))
	
