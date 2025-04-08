extends CollisionShape2D

func disable_shape():
	set_deferred("disabled", true)

func enable_shape():
	set_deferred("disabled", false)
