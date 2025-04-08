extends Node

@onready var audio_stream_player = $Song1
@onready var audio_stream_player_2 = $Song2
@onready var audio_stream_player_3 = $Song3
@onready var audio_stream_player_4 = $Song4
@onready var audio_stream_player_5 = $Song5
@onready var audio_stream_player_6 = $Song6
@onready var audio_stream_player_7 = $Song7

# Called when the node enters the scene tree for the first time.
#on ready it starts the first song
func _ready():
	audio_stream_player.play_song()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# checking for N to be pressed to skip song
func _process(delta):
	if Input.is_action_just_pressed("skip_song"):
		skip_song()
		
#Used to skip backgound music playing ; checks which is playing and moves to next
func skip_song():
	if audio_stream_player.playing == true:
		audio_stream_player.stop()
		audio_stream_player_2.play_song()
		
	elif audio_stream_player_2.playing == true: 
		audio_stream_player_2.stop()
		audio_stream_player_3.play_song()
	
	elif audio_stream_player_3.playing == true:
		audio_stream_player_3.stop()
		audio_stream_player_4.play_song()
		
	elif audio_stream_player_4.playing == true:
		audio_stream_player_4.stop()
		audio_stream_player_5.play_song()
	
	elif audio_stream_player_5.playing == true:
		audio_stream_player_5.stop()
		audio_stream_player_6.play_song()
	
	elif audio_stream_player_6.playing == true:
		audio_stream_player_6.stop()
		audio_stream_player_7.play_song()
	
	else: 
		audio_stream_player_7.stop()
		audio_stream_player.play_song()

#signals for keeping background music flowing ; on finish starts next song
func _on_audio_stream_player_finished():
	audio_stream_player_2.play_song()
	
func _on_audio_stream_player_2_finished():
	audio_stream_player_3.play_song()
	
func _on_audio_stream_player_3_finished():
	audio_stream_player_4.play_song()
	
func _on_audio_stream_player_4_finished():
	audio_stream_player_5.play_song()

func  _on_audio_stream_player_5_finished():
	audio_stream_player_6.play_song()

func _on_song_6_finished():
	audio_stream_player_7.play_song()

func _on_song_7_finished():
	audio_stream_player.play_song()
