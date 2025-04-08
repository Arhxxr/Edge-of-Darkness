class_name PackedScenes
extends Node

# Singleton instance for the PackedScenes class.
static var instance

# Exported PackedScene variables to be set in the editor.
@export var light_ability_scene: PackedScene
@export var tower_ability_scene: PackedScene

# Initialize the PackedScenes instance or free it if one already exists.
func _init():
	if  null == PackedScenes.instance:
		PackedScenes.instance = self
	else:
		queue_free()

# Returns the light ability scene.
static func get_light_object():
	return PackedScenes.instance.light_ability_scene

# Returns the tower ability scene.
static func get_tower_object():
	return PackedScenes.instance.tower_ability_scene

# Placeholder for process function, currently doing nothing.
func _process(delta):
	pass
