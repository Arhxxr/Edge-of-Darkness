class_name PlayerGem
extends Node2D

# Variables
@export var health = 1
@export var damage = 1
var pickable = false
@onready var fog: FogMachine

func _ready():
	fog = get_tree().get_first_node_in_group("fog")

func is_pickable():
	return pickable && !fog.is_grid_fog(global_position, true)

func _on_area_2d_mouse_entered():
	pickable = true

func _on_area_2d_mouse_exited():
	pickable = false

func _input(event):
	if (event.is_action_pressed("pickup_resource") || event.is_action_released("pickup_resource")) && is_pickable() && GameManager.PlayerStates.THORHAND == GameManager.PlayerState:
		take_damage(damage)

func take_damage(damage):
	health -= damage
	if health <= 0:
		Globals.add_gem_balance(1)
		Grid.grid_cell_set_buildable(Grid.get_world_to_grid(global_position), true, true, false)
		queue_free()
		# Add signal here to collect the resource and display on HUD
