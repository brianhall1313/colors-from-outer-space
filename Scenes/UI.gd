extends Control

@onready var health_display=$PanelContainer/VBoxContainer/HBoxContainer/health_display
@onready var color_box=$PanelContainer/VBoxContainer/HBoxContainer/color
@onready var points_display=$PanelContainer/VBoxContainer/HBoxContainer/points


var health_bar:Array=[
	Rect2(1,83,30,9),
	Rect2(1,67,30,9),
	Rect2(1,51,30,9),
	Rect2(1,35,30,9),
	Rect2(1,19,30,9),
	Rect2(1,3,30,9),
	]

func update(health:int,beam_color:String,points:int):
	health_display.texture.region=health_bar[health]
	color_box.color=Color(beam_color)
	points_display.text=str(points)
	
	
