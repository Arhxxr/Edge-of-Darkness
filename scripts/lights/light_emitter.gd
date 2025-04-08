class_name LightEmitter
extends Node2D

# Exported variables to define the collider, area, and radius in the Godot editor.
@export var colliderObj: CollisionObject2D
@export var collider: CollisionShape2D
@export var area: Area2D
@export var radius = 3

var textureSize = 512

# Called every frame.
func _process(delta):
	# Update the collider's radius.
	collider.get_shape().radius = radius
	
	# Get all bodies overlapping with the area.
	var bodies: Array[Node2D] = area.get_overlapping_bodies()
	for body in bodies:
		# Check if the body is not the collider itself and belongs to the "Building" group.
		if body != colliderObj:
			# If the body is in the preview state, allow it to be placed.
			if body.STATE.PREVIEW == body.getState():
				body.setCanPlace(true)

# Triggered when a body enters the area.
func _on_area_2d_body_entered(body):
	# Enable placement if the body is a building in preview state.
	if visible and body.STATE.PREVIEW == body.getState():
		body.setCanPlace(true)

# Triggered when a body exits the area.
func _on_area_2d_body_exited(body):
	# Disable placement if the body is a building in preview state.
	if visible and body.STATE.PREVIEW == body.getState():
		body.setCanPlace(false)
