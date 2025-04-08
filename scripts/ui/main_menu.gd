extends Control

@onready var play_game_button = $Main_Menu/PlayGame
@onready var fullscreen_toggle = $OptionsCanvas/Contents/FullScreen

@onready var main_menu_canvas = $Main_Menu
@onready var difficulty_states_canvas = $DifficultyStates
@onready var options_canvas = $OptionsCanvas
@onready var tutorial_canvas = $TutorialLayer
@onready var button_sounds = get_node('AudioManager/Noises/ButtonPress')

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.game_running = false
	difficulty_states_canvas.visible = false
	
	# Ensure Toggle button is toggled when game is loaded from config
	if Globals.fullscreen:
		fullscreen_toggle.set_pressed_no_signal(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Listens for toggle button and swaps display mode
func _on_full_screen_toggled(button_pressed):
	if button_pressed:
		button_sounds._play_click()
		Globals.fullscreen = true
		Globals.fullscreen_mode()
	else:
		Globals.fullscreen = false
		Globals.fullscreen_mode()


func _on_play_game_pressed():
	tutorial_canvas.visible = true
	main_menu_canvas.visible = false


func _on_options_pressed():
	button_sounds._play_click()
	main_menu_canvas.visible = false
	options_canvas.visible = true


func _on_quit_button_pressed():
	Globals.game_config_save()
	get_tree().quit()


func _on_back_button_pressed():
	difficulty_states_canvas.visible = false
	main_menu_canvas.visible = true


func _on_back_button_options_pressed():
	options_canvas.visible = false
	main_menu_canvas.visible = true


func _on_easy_pressed():
	Globals.in_menu = false
	Globals.game_diffculty = 1
	Globals.add_rock_balance(30)
	Globals.add_wood_balance(50)
	get_tree().change_scene_to_file("res://scenes/root.tscn")


func _on_medium_pressed():
	Globals.in_menu = false
	Globals.game_diffculty = 3
	Globals.add_rock_balance(30)
	Globals.add_wood_balance(40)
	get_tree().change_scene_to_file("res://scenes/root.tscn")


func _on_hard_pressed():
	Globals.in_menu = false
	Globals.game_diffculty = 6
	Globals.add_rock_balance(30)
	Globals.add_wood_balance(30)
	get_tree().change_scene_to_file("res://scenes/root.tscn")


func _on_tutorial_button_pressed():
	difficulty_states_canvas.visible = true
	tutorial_canvas.visible = false
