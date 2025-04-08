class_name TowerButton
extends Button  # Extends the Godot Button class.

# Function called when the button is pressed.
func _on_button_down():
	# Set the PlayerState in the GameManager to TOWERABILITY.
	# This typically changes the game's mode to a tower placement or tower ability state.
	GameManager.PlayerState = GameManager.PlayerStates.TOWERABILITY
