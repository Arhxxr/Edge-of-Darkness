class_name GatherResource
extends Node2D

# Variables
@export var health = 10
@export var damage = 2
var pickable = false
@onready var timer = Timer.new()


func _ready():
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position), false, true, false)
	timer.connect("timeout", Callable(self, "die"))
	add_child(timer)
	pass

func _on_area_2d_mouse_entered():
	pickable = true

func _on_area_2d_mouse_exited():
	pickable = false

func _input(event):
	if (event.is_action_pressed("pickup_resource") || event.is_action_released("pickup_resource")) && pickable && GameManager.PlayerStates.THORHAND == GameManager.PlayerState:
		if has_node("PickUpSound"):
			$PickUpSound.play()
		if has_node("ResourcePlayer"):
			$ResourcePlayer.play("resource_gather")
		take_damage(damage)

func take_damage(damage):
	add_resource(damage)
	# Add signal here to collect the resource and display on HUD
	health -= damage
	
	if health <= 0:
		if has_node("ResourcePlayer"):
			if timer.is_stopped():
				timer.start($ResourcePlayer.current_animation_length / $ResourcePlayer.speed_scale)
		else:
			die()

func add_resource(damage):
	if health > 0:
		Globals.add_rock_balance(damage)

func die():
	Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position), true, true, false)
	queue_free()
