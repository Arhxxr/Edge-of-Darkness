extends Node

# GENERICS
@onready var fullscreen := false
@onready var game_paused := false

@onready var audio_master : float
@onready var audio_music : float
@onready var audio_effects : float

@onready var game_running := false
@onready var in_menu : bool

# GAME RELATED
@onready var game_diffculty := 1
@onready var wood_balance := 0
@onready var rock_balance := 0
@onready var city_insanity := 0
@onready var city_max_insanity := 5000
@onready var current_wave := 0
@onready var gems_collected := 0

# Add to the gem balance
func add_gem_balance(balance):
	gems_collected += abs(balance)
	get_tree().call_group("gem_collected", "gem_collected")
	if (gems_collected >= 8):
		get_tree().change_scene_to_file("res://scenes/UI/you_win.tscn")

# Add to the rock balance
func add_rock_balance(balance):
	rock_balance += abs(balance)

# Add to the wood balance
func add_wood_balance(balance):
	wood_balance += abs(balance)

# Add to the rock balance
func minus_rock_balance(balance):
	rock_balance -= abs(balance)

# Add to the wood balance
func minus_wood_balance(balance):
	wood_balance -= abs(balance)

# Get to the wood balance
func get_wood_balance():
	return wood_balance

# Get to the rock balance
func get_rock_balance():
	return rock_balance

# Called when the node enters the scene tree for the first time.
func _ready():
	in_menu = true
	#ENSURES GAME CAN BE PAUSED/UNPAUSED
	process_mode = PROCESS_MODE_ALWAYS
	
	game_config_delete()
	game_config_creation()
	game_config_load()
	fullscreen_mode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fullscreen_mode():
	if Globals.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		Globals.fullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _input(event):
	# UNPAUSE GAME IF PAUSED
	if (event.is_action_pressed("ui_pause") and game_running == false):
		game_running = true
		set_game_state()
	# PAUSE GAME IF RUNNING
	elif (event.is_action_pressed("ui_pause") and game_running == true):
		game_running = false
		set_game_state()
		
	if !in_menu:
		#var tower_button = get_tree().get_root().get_node('/root/Root/UI/TowerButton')
		#var light_button = get_tree().get_root().get_node('/root/Root/UI/LightButton')
		#var thor_button = get_tree().get_root().get_node('/root/Root/UI/ThorButton')
		if (event.is_action_pressed("tower_ability")):
			GameManager.PlayerState = GameManager.PlayerStates.TOWERABILITY	
			#tower_button.set_pressed_no_signal(true)
			
		elif (event.is_action_pressed("light_ability")):
			GameManager.PlayerState = GameManager.PlayerStates.LIGHTABILITY
			#light_button.set_pressed_no_signal(true)
			
		elif (event.is_action_pressed("thor_hand")):
			GameManager.PlayerState = GameManager.PlayerStates.THORHAND
			#thor_button.set_pressed_no_signal(true)

func set_game_state():
	if(has_node("/root/Root")):
		var pause_label = get_node("/root/Root/UI/PauseLabel")
		print("GAME RUNNING: ", game_running)
		pause_label.visible = !game_running
		get_tree().paused = !game_running

### DEBUG REMOVE CONFIG FOR TESTING ###
func game_config_delete():
	print("---CONFIG DELETED---")
	DirAccess.remove_absolute("user://game.cfg")

func game_config_set_base_values(game_config_new: ConfigFile):
	game_config_new.set_value("BASE", "fullscreen", false)
	
	#default audio levels for game - between 0 -> 1.0
	game_config_new.set_value("BASE", "audio_master", 1.0)
	game_config_new.set_value("BASE", "audio_music", 0.5)
	game_config_new.set_value("BASE", "audio_effects", 0.5)

func game_config_creation():
	var game_config_new = ConfigFile.new()
	var new_save = game_config_new.load("user://game.cfg")
	
	if new_save != OK:
		print("ERROR: Creating New Base Config with default vars")
		game_config_set_base_values(game_config_new)
		game_config_new.save("user://game.cfg")
		return

func game_config_load():
	var game_config = ConfigFile.new()
	var game_config_file = game_config.load("user://game.cfg")
	
	if game_config_file != OK:
		print("--- ERROR: CANNOT LOAD GAME CONFIG ---")
		return

	print("SUCCESS: LOADING CONFIG INTO VARS")
	for config in game_config.get_sections():
		fullscreen = game_config.get_value(config, "fullscreen")
		audio_master = game_config.get_value(config, "audio_master")
		audio_music = game_config.get_value(config, "audio_music")
		audio_effects = game_config.get_value(config, "audio_effects")

func game_config_save():
	var game_config_new = ConfigFile.new()
	var new_save = game_config_new.load("user://game.cfg")
	### PLACE ALL CONFIG HERE FROM GAME
	print("--- SAVING GAME ---")
	game_config_new.set_value("BASE", "fullscreen", fullscreen)
	game_config_new.set_value("BASE", "audio_master", audio_master)
	game_config_new.set_value("BASE", "audio_music", audio_music)
	game_config_new.set_value("BASE", "audio_effects", audio_effects)
	
	game_config_new.save("user://game.cfg")

func cleanup():
	#TEMP PLACE FOR IT SINCE ITS GLOBAL
	wood_balance = 0
	rock_balance = 0
	city_insanity = 0
	current_wave = 0
	gems_collected = 0
	in_menu = true
	
	game_running = false
	set_game_state()
	game_config_save()
