extends Node2D

const SPEED: float = 200.0

@onready var sprite=$Sprite2D

var limit:int=850
var life:int=20
var tripped:bool=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.current_state=="play" or Global.current_state=="setup":
		if position.y<limit:
			position.y += delta*SPEED
		elif position.y>=limit and tripped==false:
			tripped=true
			$Timer.start()

func _on_area_2d_body_entered(body):
	if body.has_method("repair"):
		GlobalSignalBus.repair.emit()
		queue_free()



func timer_out():
	$blink.wait_time*=.9
	visible=not visible
	life-=1
	if life<=0:
		queue_free()

func _on_timer_timeout():
	$Timer.stop()
	$blink.start()
