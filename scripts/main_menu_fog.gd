extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Clear fog 
	var fog = get_tree().get_first_node_in_group("fog")
	
	# Top right 
	fog.update_fog(Vector2(2, 1), false)
	fog.update_fog(Vector2(1, 1), false)
	fog.update_fog(Vector2(1, 2), false)
	
	# Bottom right 
	fog.update_fog(Vector2(1, 7), false)
	fog.update_fog(Vector2(1, 8), false)
	fog.update_fog(Vector2(2, 8), false)
	
	# Top right
	fog.update_fog(Vector2(15, 1), false)
	fog.update_fog(Vector2(16, 1), false)
	fog.update_fog(Vector2(16, 2), false)
	
	# Bottom right
	fog.update_fog(Vector2(16, 7), false)
	fog.update_fog(Vector2(16, 8), false)
	fog.update_fog(Vector2(15, 8), false)
