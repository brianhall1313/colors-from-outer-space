extends Node2D

const SPEED: float = 200.0
var life:int=20
var tripped:bool=false

var limit:int=850


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.current_state=="play" or Global.current_state=="setup":
		if position.y<limit:
			position.y += delta*SPEED
		elif position.y>=limit and tripped==false:
			tripped=true
			$Timer.start()


func _on_area_2d_body_entered(body):
	if body.has_method("activate_rainbow_beam"):
		GlobalSignalBus.rainbow.emit()
		queue_free()


func timer_out():
	$blink.wait_time*=.9
	visible=not visible
	life-=1
	if life<=0:
		queue_free()
	$blink.start()

func _on_timer_timeout():
	$Timer.stop()
	$blink.start()
