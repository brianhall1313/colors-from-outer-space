extends Node2D



func _on_area_2d_body_entered(body):
	if body.has_method("repair"):
		GlobalSignalBus.repair.emit()
		queue_free()
