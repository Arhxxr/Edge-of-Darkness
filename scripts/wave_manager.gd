extends Node2D


var enemy_script: EnemySpawner

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_script = get_tree().get_first_node_in_group("enemy_group")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_wave_timer_timeout():
	Globals.current_wave+=1
	enemy_script.generate_wave()
	get_tree().call_group("Building", "survived_wave")
	
	pass # Replace with function body.
