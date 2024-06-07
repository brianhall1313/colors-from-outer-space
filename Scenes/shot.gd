extends Node2D

const SPEED: float = 700.0

var color:String = "red"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= delta*SPEED


func color_change(new:String):
	color = new
	modulate = Color(new)


func _on_area_2d_area_entered(area):
	if area.get_parent().has_method("get_hit"):
		area.get_parent().get_hit(color)
		queue_free()
