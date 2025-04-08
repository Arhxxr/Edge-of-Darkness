extends Timer
class_name Timer_Deleter

# WE USE THIS TIMER WHEN WE WANT TO DELETE AUTOMATICALLY FROM THE SCENE

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("timeout", delete)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func delete():
	self.queue_free()
