extends Node2D

const SPEED: float = 700.0
@onready var rainbow=preload("res://Resources/rainbow_beam.tres")
var color:String = "red"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.current_state=="play" or Global.current_state=="setup":
		position.y -= delta*SPEED


func color_change(new:String):
	color = new
	modulate = Color(new)
	if color=="white":
		$Sprite2D.material=rainbow
	else:
		$Sprite2D.material=null


func _on_area_2d_area_entered(area):
	if area.get_parent().has_method("get_hit"):
		area.get_parent().get_hit(color)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
