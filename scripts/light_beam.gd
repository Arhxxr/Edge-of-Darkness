extends Node2D

var damage = 50

func _on_area_2d_body_entered(body):
	if (body.is_in_group("enemies") && body.has_method("take_damage")):
		body.take_damage(damage)
		queue_free()
