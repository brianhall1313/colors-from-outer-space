extends Node2D

func _on_area_2d_body_entered(body):
	if body.has_method("activate_rainbow_beam"):
		GlobalSignalBus.rainbow.emit()
		queue_free()
