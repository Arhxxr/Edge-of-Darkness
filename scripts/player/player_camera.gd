extends Camera2D

# Variables for camera movement and zoom.
var startMousePos : Vector2
var zoomFactor = 1

# Called when the node enters the scene tree.
func _ready():
	pass  # Placeholder for any initialization code.

var mouse_start_pos 
var screen_start_position  
var dragging = false   

func _input(event):
	if event.is_action("move_camera"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		var size = get_viewport_rect().size
		position = ((mouse_start_pos - event.position) / zoom) + screen_start_position
		position.x = clamp(position.x, limit_left + size.x/2, limit_right - size.x/2)
		position.y = clamp(position.y, limit_top + size.y/2, limit_bottom - size.y/2)
		
# Called every frame.
func _process(delta):
	# Handling zoom in and out functionality.
	if Input.is_action_just_released("zoom_in"):
		zoomFactor += 5 * delta
	if Input.is_action_just_released("zoom_out"):
		zoomFactor -= 5 * delta

	# Clamping the zoom factor.
	zoomFactor = clampf(zoomFactor, 0.5, 2)

	# Applying the zoom factor to the camera.
	set_zoom(Vector2(zoomFactor, zoomFactor))
