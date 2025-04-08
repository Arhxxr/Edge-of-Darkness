class_name TowerWeapon
extends Node2D

var target
@export var projectile: PackedScene
@export var reload_time: float = 1

var tower: PlayerTower
var can_fire = true

func _ready():
	tower = get_parent()
	if has_node("Timer"):
		$Timer.set_one_shot(true)

func set_target(_target):
	target = _target
	fire()

func fire():
	if can_fire && is_instance_valid(target):
		var _projectile: TowerProjectile = projectile.instantiate()
		_projectile.set_target(target)
		_projectile.collider_radius = tower.aoe_radius
		add_child(_projectile)
		can_fire = false
		if has_node("Timer") && $Timer.is_stopped():
			$Timer.start(reload_time)

func _on_timer_timeout():
	can_fire = true
	fire()
