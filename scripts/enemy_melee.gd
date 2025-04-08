class_name Enemy
extends CharacterBody2D

enum STATE {IDLE, AGGRO}

var state: STATE = STATE.IDLE

var target
var health = 100
var speed = 10 * Globals.game_diffculty
var attacking_distance = 60
var slow = 0

@onready var attacking_damage := (10 * Globals.game_diffculty) + Globals.current_wave
@onready var attacking_timer: Timer = $AttackTimer
@onready var animation = $Animation
@onready var attack_sound = $AttackSound
@onready var death_sound = $DeathSound

var target_global_position
var direction
var slow_timer: Timer = Timer.new()

var dot_timer: Timer = Timer.new()
var dot_damage: float = 0

var death_timer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	slow_timer.connect("timeout", Callable(self, "remove_slow"))
	slow_timer.set_one_shot(true)
	add_child(slow_timer)
	
	death_timer.connect("timeout",Callable(self, "queue_free"),CONNECT_ONE_SHOT)
	death_timer.set_one_shot(true)
	add_child(death_timer)
	
	dot_timer.connect("timeout", Callable(self, "remove_dot"))
	dot_timer.set_one_shot(true)
	add_child(dot_timer)

func take_damage(damage):
	health -= abs(damage)
	
	if health <= 0:
		die()

func apply_slow(_slow, duration):
	slow = clamp(_slow, 0, 1)
	slow_timer.start(duration)

func remove_slow():
	slow = 0


func apply_dot(_damage, duration):
	dot_damage = clamp(_damage, 0, 500)
	dot_timer.start(duration)

func remove_dot():
	dot_damage = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	take_damage(dot_damage * delta)
	match state:
		STATE.IDLE:
			idle_state(delta)
		STATE.AGGRO:
			aggro_state(delta)

func change_state(_state: STATE):
	state = _state
	if (STATE.AGGRO == state):
		self.add_to_group("enemy_state_aggro")
	else:
		self.remove_from_group("enemy_state_aggro")

func idle_state(delta):
	var fog: FogMachine = get_tree().get_first_node_in_group("fog")
	if (fog.has_method("is_grid_fog") && !fog.is_grid_fog(global_position)):
		change_state(STATE.AGGRO)

func aggro_state(delta):
	if (target == null):
		find_target()
	else:
		target_global_position = global_position.distance_to(target.global_position)
		
		if target_global_position <= attacking_distance:
			if attacking_timer.is_stopped():
				attacking_timer.start()
		else:
			direction = ( target.global_position - global_position ).normalized()
			velocity = (direction * speed * (1 - slow))
			move_and_slide()

func reset_target():
	target = null
	find_target()

func find_target():
	var min_distance = 99999;
	var towers = get_tree().get_first_node_in_group("structures").get_children()
	for tower in towers:
		var distance = global_position.distance_to(tower.global_position)
		if (distance < min_distance):
			min_distance = distance
			target = tower
	

func attack_target():
	if is_instance_valid(target) and target.has_method("take_damage"):
		attacking_timer.start()
		animation.play("attacking")
		target.take_damage(attacking_damage)
		attack_sound.play()
		#ATTACK ANIMATION AND SOUND PLAYED HERE PLEASE
		
		#print("ATTACKING: HEALTH IS ", str(target.health))


func _on_attack_timer_timeout():
	# checks if they are within attacking range
	if (is_instance_valid(target)):
		if target_global_position <= attacking_distance:
			attack_target()

func die():
	if death_timer.is_stopped():
		death_sound.play()
		speed = 0
		death_timer.start(1)
