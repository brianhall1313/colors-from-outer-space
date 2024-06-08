extends Node2D

const STEP:int = 64

@onready var beam : PackedScene = preload("res://Scenes/shot.tscn")
@onready var invader : PackedScene = preload("res://Scenes/invader.tscn")
@onready var timer=$Timer
@onready var enemy_manager=$enemies
@onready var player = $player

var default_time:float=2.0
var default_next:String="right"
var level:int = 0
var check_win:bool = false
var color_list:Array[String] = ["red","blue","yellow","purple","orange","green","white"]
var level_var:=[["red","blue","yellow"],
["red","red","blue","blue","yellow","yellow","purple","orange","green"],
["red","blue","yellow","purple","orange","green"],
["red","blue","yellow","purple","orange","green","purple","orange","green"],
["red","blue","yellow","purple","orange","green","purple","orange","green","white"],
["red","blue","yellow","purple","orange","green","purple","orange","green","white","white"],
["red","blue","yellow","purple","orange","green","purple","orange","green","white","white","white"],
["red","blue","yellow","purple","orange","green","purple","orange","green","white","white","white","white"],

]
var columns:int=7
var rows:int=5
var count: int = 0
var distance: int = 4
var direction:String = "down"
var next:String = "right"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect_signal_bus()
	level_setup()
	timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if check_win:
		has_won()



func connect_signal_bus():
	GlobalSignalBus.connect("shoot",spawn_beam)
	GlobalSignalBus.connect("invader_death",on_invader_death)


func level_setup():
	var level_select:int
	if level<len(level_var):
		level_select=level
	else:
		level_select=len(level_var)-1
	for row in range(1,rows):
		for column in range(1,columns):
			var point:Vector2=Vector2(column*STEP,row*STEP)
			spawn_invader(point,level_var[level_select].pick_random())
	timer.wait_time=default_time
	timer.stop()
	timer.start()
	next=default_next
	count=0
	direction = "down"



func invader_progress():
	if count >= distance:
		count = 0
		direction = "down"
		if timer.wait_time >.3:
			timer.wait_time-=.2
		if next == "left":
			next = "right"
		else:
			next = "left"
	else:
		if count==0:
			if next == "left":
				direction = "left"
			else:
				direction = "right"
		count+=1


func has_won():
	if len(enemy_manager.get_children())==0:
		check_win = false
		level+=1
		print("YOU WIN SUCKAH!")
		level_setup()




func spawn_invader(pos:Vector2,color:String):
	var new = invader.instantiate()
	enemy_manager.add_child(new)
	new.position = pos
	new.change_color(color)



func spawn_beam(beam_color):
	var new_shot = beam.instantiate()
	add_child(new_shot)
	new_shot.position = player.position
	new_shot.color_change(beam_color)


func _on_timer_timeout():
	invader_progress()
	
	for enemy in enemy_manager.get_children():
		if direction == "down":
			enemy.position.y += STEP
		elif direction=="right":
			enemy.position.x += STEP
		elif direction=="left":
			enemy.position.x -= STEP



func on_invader_death():
	check_win = true


func _on_landing_zone_area_entered(area):
	print("Game Over Sucker")
