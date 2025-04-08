extends StaticBody2D
class_name PlayerTower

@export var activeNode: Node2D  # An exported Node2D, typically used for visualization.
@export var collider: CollisionShape2D  # Exported CollisionShape2D for collision handling.

# Structure health and states.
enum STATE {DISABLED, BUILDING, BUILT, DESTROYED, PREVIEW}  # Defines possible states of the tower.
var currentState: STATE = STATE.DISABLED  # Initial state of the tower.
var maxHealth = 100  # Maximum health of the tower.
var health = maxHealth  # Current health, starts at maximum.
var buildTime = 1  # Total time required to build the tower.
var buildProgress = 0  # Current progress of building.
var buildSpeed = 1  # Speed of building progress.
var canBuild = false  # Flag to determine if building is possible.
var isBlocked = false  # Flag to determine if building is blocked.

@export var max_target_distance = 64 * 5;
var target = null # Target enemy

@export var wood_cost = 5
@export var rock_cost = 10

@export var aoe_radius: float = 0

var weapon: TowerWeapon

var fog: FogMachine

var can_upgrade = false

@export var fire_tower: PackedScene
@export var ice_tower: PackedScene
@export var light_tower: PackedScene

var tower_packedscene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	fog = get_tree().get_first_node_in_group("fog")
	weapon = get_node("TowerWeapon")
	
	if has_node("TowerPlayer"):
		$TowerPlayer.connect("animation_finished", Callable(self, "_on_tower_player_animation_finished"))

	if (STATE.BUILT != currentState && null != activeNode):
		activeNode.hide()  # Hide the active node if the tower is not in the BUILT state.

# Determines if the tower can be placed based on build and block flags.
func canPlace():
	return (
			Grid.grid_cell_buildable(Grid.get_world_to_grid(global_position)) &&
			Globals.get_rock_balance() >= rock_cost &&
			Globals.get_wood_balance() >= wood_cost
		)

# Setter method to update the ability to place the tower.
func setCanPlace(place: bool):
	canBuild = place

# Getter method for the current state of the tower.
func getState():
	return currentState

# Changes the state of the tower and updates the active node visibility accordingly.
func changeState(state: STATE):
	currentState = state

	if (STATE.BUILDING == currentState):
		Globals.minus_rock_balance(rock_cost)
		Globals.minus_wood_balance(wood_cost)
	
	if (STATE.BUILT == currentState):
		collider.set_disabled(false)
	
	if (STATE.DESTROYED == currentState):
		if has_node("TowerPlayer"):
			$TowerPlayer.play("tower_destroy")
	
	if (null != activeNode):
		if (STATE.BUILT == currentState):
			activeNode.show()
		else:
			activeNode.hide()

# Handles the building step of the tower.
func buildStep(delta):
	if (STATE.BUILDING != currentState):
		return  # Exit if not in building state.
	
	queue_redraw()  # Request a redraw for visual updates.

	# Increment building progress and check if building is complete.
	if (buildProgress < buildTime):
		buildProgress += buildSpeed * delta
	if (buildProgress >= buildTime):
		buildProgress = buildTime
		changeState(STATE.BUILT)  # Change state to BUILT.

# Handles steps when the tower is in the built state.
func builtStep(delta):
	if (STATE.BUILT != currentState):
		return  # Exit if not in built state.
	
	# Find nearest target.
	if (target == null):
		find_target()
	else:
		if (
			global_position.distance_to(target.global_position) > max_target_distance ||
			fog.is_grid_fog(target.global_position)
		):
			target = null
			weapon.set_target(target)
		
# Method to apply damage to the tower and change state if health is depleted.
func take_damage(damage):
	health -= abs(damage)  # Apply damage, ensuring it's a positive value.
	if (health <= 0):
		health = 0
		changeState(STATE.DESTROYED)  # Change state to DESTROYED if health is depleted.

# Called every frame, handles state-specific actions.
func _process(delta):
	match currentState:
		STATE.BUILDING:
			buildStep(delta)
		STATE.BUILT:
			builtStep(delta)
		STATE.PREVIEW:
			collider.set_disabled(true)

func find_target():
	var min_distance = max_target_distance;
	var enemies = get_tree().get_nodes_in_group("enemy_state_aggro")
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if (distance < min_distance && !fog.is_grid_fog(enemy.global_position)):
			min_distance = distance
			target = enemy
			weapon.set_target(target)

func die():
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position), true, true)
	if tower_packedscene:
		createItem(tower_packedscene)
		
	queue_free()

func _on_tower_player_animation_finished(anim_name):
	if ("tower_destroy" == anim_name):
		die()

func survived_wave():
	if has_node("TowerUpgrade"):
		$TowerUpgrade.visible = true

# Creates an instance of the tower and positions it.
func createItem(tempItem: PackedScene):
	var _item = tempItem.instantiate()  # Instantiate the passed PackedScene.
	_item.global_position = global_position  # Set the position to the center of the grid cell.
	_item.set_z_index(Grid.get_world_to_grid(global_position).y)  # Set the z-index based on mouse position.
	Grid.grid_cell_set_buildable(Grid.get_mouse_to_grid(), false, true)
	get_tree().call_group("enemies", "reset_target")
	_item.changeState(_item.STATE.BUILDING)
	get_parent().add_child(_item)

func _on_item_list_item_selected(index):
	tower_packedscene = fire_tower
	match index:
		0:
			tower_packedscene = fire_tower
		1:
			tower_packedscene = ice_tower
		2:
			tower_packedscene = light_tower
	
	take_damage(maxHealth)
