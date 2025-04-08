extends Node

# Enumeration for different player states.
enum PlayerStates {THORHAND, TOWERABILITY, LIGHTABILITY}

# Variable to hold the current state of the player. Default is set to THORHAND.
var PlayerState = PlayerStates.THORHAND

# Static variable 'instance' for the GameManager. This allows it to be accessed globally.
static var instance: GameManager

func _process(delta):
	var mouseToCell = Grid.get_mouse_to_grid()
	var fog = get_tree().get_first_node_in_group("fog")
	if is_instance_valid(fog):
		fog.temporary_unfog(mouseToCell)
	

