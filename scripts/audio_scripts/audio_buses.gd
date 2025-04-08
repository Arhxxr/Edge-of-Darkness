extends CanvasLayer

@onready var master_bus_name := "Master"
@onready var music_bus_name := "music"
@onready var sfx_bus_name := "sfx"

@onready var master_slider := $Contents/master_bus
@onready var music_slider := $Contents/music_bus
@onready var sfx_slider := $Contents/sfx_bus

#@onready var sliders := [master_slider, music_slider, sfx_slider]
@onready var bus_collection := { 
	master_bus_name:master_slider,
	music_bus_name:music_slider,
	sfx_bus_name:sfx_slider
}

var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	master_slider.value = Globals.audio_master
	music_slider.value = Globals.audio_music
	sfx_slider.value = Globals.audio_effects
	
	#goes through each audio bus and sets the default value
	for bus in bus_collection:
		bus_index = AudioServer.get_bus_index(bus)
		var slider_value = bus_collection[bus].value
		
		slider_value = linear_to_db(AudioServer.get_bus_volume_db(bus_index))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_master_bus_value_changed(value):
	Globals.audio_master = value
	bus_index = AudioServer.get_bus_index(master_bus_name)
	
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(Globals.audio_master)
	)

func _on_music_bus_value_changed(value):
	Globals.audio_music = value
	bus_index = AudioServer.get_bus_index(music_bus_name)
	
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(Globals.audio_music)
	)


func _on_sfx_bus_value_changed(value):
	Globals.audio_effects = value
	bus_index = AudioServer.get_bus_index(sfx_bus_name)
	
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(Globals.audio_effects)
	)
