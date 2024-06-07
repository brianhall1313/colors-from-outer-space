extends Node2D

const STEP:int = 50

@onready var beam : PackedScene = preload("res://Scenes/shot.tscn")
@onready var invader : PackedScene = preload("res://Scenes/invader.tscn")
@onready var timer=$Timer
@onready var enemy_manager=$enemies
@onready var player = $player

var count: int = 0
var distance: int = 3
var direction:String = "right"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect_signal_bus()
	spawn_invader(Vector2(288,288),"orange")
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func connect_signal_bus():
	GlobalSignalBus.connect("shoot",spawn_beam)



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
	for enemy in enemy_manager.get_children():
		if direction == "down":
			enemy.position.y += STEP
		elif direction=="right":
			enemy.position.x += STEP
		elif direction=="left":
			enemy.position.x -= STEP
