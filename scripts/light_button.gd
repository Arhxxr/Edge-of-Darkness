# Declares a new class named 'LightButton' that extends Godot's built-in Button class.
class_name LightButton
extends Button

# Function called when the button is pressed.
func _on_button_down():
	# Changes the PlayerState in the GameManager to LIGHTABILITY.
	GameManager.PlayerState = GameManager.PlayerStates.LIGHTABILITY


func _on_thor_button_down():
		# Changes the PlayerState in the GameManager to THORHAND.
	GameManager.PlayerState = GameManager.PlayerStates.THORHAND
