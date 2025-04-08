extends Area2D


func _enable_damage_timer_timeout():
	set_deferred("monitorable", true)
	set_deferred("monitoring", true)

func _disable_damage_timer_timeout():
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
