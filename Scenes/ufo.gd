extends Node2D

const SPEED: float = 100.0

var point_value:int=10000
var direction:String=''
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.current_state=="play" or Global.current_state=="setup":
		if direction=="right":
			position.x += delta*SPEED
		elif direction=="left":
			position.x -= delta*SPEED
	if position.x<-200 or position.x>1000:
		queue_free()


func spawn(new_position:Vector2,new_direction:String):
	position=new_position
	direction=new_direction


func get_hit(color):
	GlobalSignalBus.score.emit(point_value)
	GlobalSignalBus.explosion.emit(position,color)
	GlobalSignalBus.ufo_death.emit()
	queue_free()
