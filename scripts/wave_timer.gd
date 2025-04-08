extends RichTextLabel

@onready var wave_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	wave_timer = get_node("%WaveTimer")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	text = str(wave_timer.time_left)
	pass
