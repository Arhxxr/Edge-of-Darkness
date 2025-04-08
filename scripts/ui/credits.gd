extends Node2D

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
