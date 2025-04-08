extends ProgressBar

var displayed_insanity = 0;

# Set max value to lose condition 
func _ready():
	max_value = Globals.city_max_insanity


# Lerp insanity value
func _process(delta):
	displayed_insanity = lerpf(displayed_insanity, Globals.city_insanity, 0.1)
	value = displayed_insanity
