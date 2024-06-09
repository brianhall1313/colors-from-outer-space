extends Node2D

@onready var animated_sprite = $animated_sprite
@onready var colorblind_label = $color_blind
@onready var colorblind_text=$color_blind/Label
@onready var attack_timer=$attack_timer

var point_value:int=100
var sprite_list:Array[String]=["default","friend","buddy","dude",'guy']
var color: String = "white"
var minimum:float=5
var maximum:float=45

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite.animation=sprite_list.pick_random()
	change_color("blue")
	animated_sprite.play()
	attack_timer.wait_time=randf_range(minimum,maximum)
	attack_timer.start()


func change_color(new_color):
	animated_sprite.modulate=Color(new_color)
	color=new_color
	if Global.color_blind_mode:
		colorblind_label.show()
		colorblind_text.text=color
	else:
		colorblind_label.hide()
	

func get_hit(beam_color:String):
	if color == beam_color or beam_color == "white":
		GlobalSignalBus.invader_death.emit()
		GlobalSignalBus.score.emit(point_value)
		GlobalSignalBus.explosion.emit(position,beam_color)
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
	if color == "white":
		if beam_color == "blue":
			change_color("orange")
		elif  beam_color == "yellow":
			change_color("purple")
		elif  beam_color == "red":
			change_color("green")
		return
		


func pause():
	attack_timer.paused=not attack_timer.paused


func _on_attack_timer_timeout():
	attack_timer.wait_time=randf_range(minimum,maximum)
	GlobalSignalBus.invader_shoot.emit(self.position,self.color)
