extends ColorRect

var fadeValue = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	color.a = 1.5
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	color.a -= fadeValue * delta
	pass


func _on_timer_2_timeout():
	fadeValue = -fadeValue
	pass # Replace with function body.
