extends Control

@onready var health_display=$PanelContainer/VBoxContainer/HBoxContainer/health_display
@onready var color_box=$PanelContainer/VBoxContainer/HBoxContainer/color
@onready var points_display=$PanelContainer/VBoxContainer/HBoxContainer/points
@onready var message_timer=$message_timer
@onready var system_message=$VBoxContainer/system_message
@onready var game_over_screen=$game_over
@onready var final_score=$game_over/VBoxContainer/HBoxContainer/final_score


@onready var rainbow=preload("res://Resources/rainbow_beam.tres")

signal start
signal end

func _ready():
	toggle_system_message()


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
	if beam_color == "white":
		color_box.material=rainbow
	else:
		color_box.material=null
	color_box.color=Color(beam_color)
	points_display.text=str(points)

func game_over(points:int):
	game_over_screen.show()
	$game_over/VBoxContainer/HBoxContainer/final_score.text = str(points)


func message_received(message:String):
	system_message.text=message
	toggle_system_message()
	#message_timer.start()
	var tween = get_tree().create_tween()
	var move_range:int = 100
	var mid_x = system_message.position.x
	var start_x = system_message.position.x - move_range
	var end_x = system_message.position.x + move_range
	tween.set_parallel(true)
	tween.tween_property(system_message, "position:x", mid_x, 1).from(start_x)
	tween.tween_property(system_message,"modulate",Color(1,1,1,1),1).from(Color(1,1,1,0))
	tween.set_parallel(false)
	tween.tween_interval(2)
	await tween.finished
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(system_message, "position:x", end_x, 1).from(mid_x)
	tween.tween_property(system_message,"modulate",Color(1,1,1,0),1).from(Color(1,1,1,1))
	await tween.finished
	_on_message_timer_timeout()
	
	
	
	


func toggle_system_message():
	system_message.visible=not system_message.visible


func _on_message_timer_timeout():
	if system_message.visible:
		end.emit()
	toggle_system_message()
	


func _on_restart_button_up():
	get_tree().reload_current_scene()


func _on_quit_button_up():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
