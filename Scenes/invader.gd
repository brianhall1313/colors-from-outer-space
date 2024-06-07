extends Node2D

@onready var animated_sprite = $animated_sprite


var color: String = "blue"

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.play()
	

func change_color(new_color):
	modulate=Color(new_color)
	color=new_color
	

func get_hit(beam_color:String):
	if color == beam_color:
		queue_free()
	if color == "purple":
		if beam_color == "red":
			change_color("blue")
		elif  beam_color == "blue":
			change_color("red")
		return
	if color == "orange":
		if beam_color == "red":
			change_color("yellow")
		elif  beam_color == "yellow":
			change_color("red")
		return
	if color == "green":
		if beam_color == "blue":
			change_color("yellow")
		elif  beam_color == "yellow":
			change_color("blue")
		return
		
