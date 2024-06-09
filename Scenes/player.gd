extends CharacterBody2D

const SPEED:float = 700.0
const TIME:float = 10.0
@onready var player_color = $player_color
@onready var rainbow_beam_timer=$rainbow_beam_timer
var default_beam: String = "red"
var beam_color: String = default_beam
var previous_color:String = ""
var maximum_health:int=5
var current_health:int=maximum_health



func _ready():
	player_color.color = Color(default_beam)
	rainbow_beam_timer.wait_time=TIME
	GlobalSignalBus.connect("repair",repair)
	GlobalSignalBus.connect("rainbow",activate_rainbow_beam)
	


func _physics_process(delta):
	if Global.current_state=="play" or Global.current_state=="setup":
		if Input.is_action_pressed("left"):
			velocity.x -= 0.1
		elif Input.is_action_pressed("right"):
			velocity.x += 0.1
		else:
			if velocity.x > 0:
				velocity.x -= 0.35
			elif velocity.x < 0:
				velocity.x += 0.35
			if abs(velocity.x) < 0.35:
				velocity = Vector2.ZERO
		if abs(velocity.x) > 1:
			velocity.x = velocity.x / abs(velocity.x)
		var result = move_and_collide(velocity * delta * SPEED)
		if result:
			velocity = Vector2.ZERO

func _input(event):
	if Global.current_state=="play" or Global.current_state=="setup":
		if event.is_action_released("fire"):
			GlobalSignalBus.shoot.emit(beam_color)
		elif event.is_action_pressed("blue"):
			change_color("blue")
		elif event.is_action_pressed("red"):
			change_color("red")
		elif event.is_action_pressed("yellow"):
			change_color("yellow")
		


func change_color(new_color:String):
	previous_color=beam_color
	beam_color = new_color
	GlobalSignalBus.update_ui.emit()
	player_color.color = Color(new_color)


func activate_rainbow_beam():
	if beam_color != "white":
		change_color("white")
	rainbow_beam_timer.start()




func get_hit():
	current_health-=1
	GlobalSignalBus.player_damage.emit()
	if current_health<=0:
		GlobalSignalBus.explosion.emit(position)
		GlobalSignalBus.player_death.emit()
		queue_free()
		

func repair():
	current_health=maximum_health
	GlobalSignalBus.update_ui.emit()




func _on_rainbow_beam_timer_timeout():
	beam_color = previous_color
	rainbow_beam_timer.stop()
