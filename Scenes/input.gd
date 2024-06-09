extends Node

signal toggle_pause

func _unhandled_input(event):
	if Global.current_state=="play" or Global.current_state=="menu":
		if event.is_action_released("back"):
			toggle_pause.emit()

