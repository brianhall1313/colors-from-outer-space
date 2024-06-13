extends Node2D

const STEP:int = 64

@onready var bonuses:Dictionary={"repair":preload("res://Scenes/repair_kit.tscn"),
"rainbow_beam":preload("res://Scenes/rainbow_beam.tscn")}
@onready var beam : PackedScene = preload("res://Scenes/shot.tscn")
@onready var invader : PackedScene = preload("res://Scenes/invader.tscn")
@onready var invader_shot: PackedScene=preload("res://Scenes/invader_shot.tscn")
@onready var ufo:PackedScene=preload("res://Scenes/ufo.tscn")
@onready var explosion: PackedScene=preload("res://Animations/explosion.tscn")
@onready var ufo_spawn={"right":$move_right,"left":$move_left}
@onready var timer=$Timer
@onready var enemy_manager=$enemies
@onready var player = $player
@onready var ufo_delay=$ufo_delay
@onready var ui=$UI
@onready var bonus_spawn=$Path2D/bonus


var next_bonus_spawn:String=""
var next_bonus_position:Vector2
var bonus_list:Array=["repair","rainbow_beam"]
var invader_score:int=100
var points:int = 0
var default_time:float=2.5
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
	update_ui()
	new_level()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if check_win:
		has_won()
	if next_bonus_spawn:
		spawn_bonus(next_bonus_spawn)
		next_bonus_spawn=""


func connect_signal_bus():
	GlobalSignalBus.connect("shoot",spawn_beam)
	GlobalSignalBus.connect("score",score)
	GlobalSignalBus.connect("repair",repair)
	GlobalSignalBus.connect("rainbow",rainbow)
	GlobalSignalBus.connect("update_ui",update_ui)
	GlobalSignalBus.connect("invader_shoot",spawn_invader_shot)
	GlobalSignalBus.connect("invader_death",on_invader_death)
	GlobalSignalBus.connect("player_damage",player_damage)
	GlobalSignalBus.connect("player_death",player_death)
	GlobalSignalBus.connect("explosion",spawn_explosion)
	GlobalSignalBus.connect("ufo_death",ufo_death)
	


func update_ui():
	ui.update(player.current_health,player.beam_color,points)


func game_over():
	full_stop()
	Global.change_state("dead")
	ui.game_over(points)


func full_stop():
	timer.stop()
	for enemy in enemy_manager.get_children():
		enemy.attack_timer.stop()

func toggle_pause():
	if Global.current_state=="menu":
		Global.change_state("play")
	else:
		Global.change_state("menu")
	get_tree().paused = not get_tree().paused
	#timer.paused = not timer.paused
	#for enemy in enemy_manager.get_children():
		#enemy.pause()


func new_level():
	var new_message:String="New Stage:\nLevel "+str(level+1)
	ui.message_received(new_message)



func level_setup():
	update_ui()
	var level_select:int
	if level<len(level_var):
		level_select=level
	else:
		level_select=len(level_var)-1
	for row in range(1,rows):
		for column in range(1,columns):
			var point:Vector2=Vector2(column*STEP,row*STEP)
			spawn_invader(point,level_var[level_select].pick_random())
	Global.change_state("play")
	timer.wait_time=default_time
	timer.start()
	next=default_next
	count=0
	direction = "down"
	ufo_delay.start()



func invader_progress():
	if count >= distance:
		count = 0
		direction = "down"
		if timer.wait_time >.3:
			timer.wait_time*=(.80-(.01*level))
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
		Global.change_state("setup")
		ufo_delay.stop()
		new_level()


func player_death():
	game_over()


func ufo_death(death_position):
	var pick=bonus_list.pick_random()
	next_bonus_spawn = pick
	next_bonus_position=death_position
	spawn_explosion(death_position,"white")






func spawn_bonus(pick:String):
		var new = bonuses[pick].instantiate()
		new.position=next_bonus_position
		add_child(new)


func spawn_invader(pos:Vector2,color:String):
	var new = invader.instantiate()
	enemy_manager.add_child(new)
	new.position = pos
	new.change_color(color)


func spawn_invader_shot(shot_position:Vector2,color:String):
	if Global.current_state=="play":
		var new = invader_shot.instantiate()
		new.position = shot_position
		add_child(new)
		new.change_color(color)
		$invader_shot.play()
		


func spawn_explosion(explosion_position,color):
	var new=explosion.instantiate()
	new.position=explosion_position
	add_child(new)
	new.modulate=Color(color)
	$explosion.play()



func spawn_beam(beam_color):
	var new_shot = beam.instantiate()
	add_child(new_shot)
	new_shot.position = player.position
	new_shot.color_change(beam_color)
	$player_shot.play()


func spawn_ufo():
	var pick=["right","left"].pick_random()
	var new=ufo.instantiate()
	add_child(new)
	new.spawn(ufo_spawn[pick].position,pick)
	var minimum:int=10+level
	var maximum:int=20+level
	ufo_delay.wait_time=randf_range(minimum,maximum)
	$ufo.play()


func repair():
	$repair.play()
	

func rainbow():
	$rainbow.play()



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

func score(p:int):
	points+=p
	update_ui()



func _on_landing_zone_area_entered(_area):
	game_over()


func _on_input_toggle_pause():
	toggle_pause()


func _on_ufo_delay_timeout():
	spawn_ufo()

func player_damage():
	update_ui()
	$player_damage.play()


func _on_ui_end():
	level_setup()
