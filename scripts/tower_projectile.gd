class_name TowerProjectile
extends Node2D

var target = null
@export var speed = 500
@export var damage = 50

@export var dot_damage = 0
@export var dot_duration: float = 0

@export var slow: float = 0
@export var slow_duration: float = 0

@export var collider_radius: float = 0

var direction
var timer: Timer

@export var destroy_on_hit: bool = true
@export var look_at_target: bool = true

var fog: FogMachine

func set_target(_target):
	target = _target
	if look_at_target:
		look_at(target.global_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	if collider_radius > 0 && has_node("Hit/HitCircle"):
		$Hit/HitCircle.shape.radius = collider_radius
	fog = get_tree().get_first_node_in_group("fog")
	if has_node("ProjectileAudio"):
		$ProjectileAudio.play()
	timer = get_node("Timer")
	if is_instance_valid(timer):
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (target != null && direction == null):
		direction = ( target.global_position - global_position ).normalized()
		if look_at_target:
			look_at(target.global_position)
	
	if (direction != null):
		if speed > 0:
			position += direction * speed * delta
			fog.temporary_unfog(Grid.get_world_to_grid(global_position))
			queue_redraw()
	else:
		queue_free()



func _on_timer_timeout():
	queue_free()

func explode():
	if has_node("AoEHit"):
		speed = 0
		$AoEHit._enable_damage_timer_timeout()
		if has_node("Hit"):
			$Hit._disable_damage_timer_timeout()
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.hide()
		if has_node("AoESprite"):
			$AoESprite.show()

func _on_area_2d_area_entered(area: Area2D):
	var enemy = area.get_parent()
	if (enemy.is_in_group("enemies") && enemy.has_method("take_damage")):
		enemy.take_damage(damage)
		if slow > 0 && enemy.has_method("apply_slow"):
			enemy.apply_slow(slow, slow_duration)
			
		if dot_damage > 0 && enemy.has_method("apply_dot"):
			enemy.apply_dot(dot_damage, dot_duration)

		explode()
		
		if (destroy_on_hit):
			queue_free()


func _on_enable_damage_timer_timeout():
	if (target != null):
		var distance = ceil(1920 / Grid.gridCellSize)
		var lastTime = 0.1 * distance
		for i in distance:
			var cell = Grid.get_world_to_grid(global_position + (Vector2(i * Grid.gridCellSize , i * Grid.gridCellSize) * direction))
			fog.temporary_unfog(cell, lastTime)
			lastTime -= 0.1
		
