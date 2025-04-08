extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var fog = get_tree().get_first_node_in_group("fog")
	fog.update_fog(global_position)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
