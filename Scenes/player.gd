extends CharacterBody2D

const SPEED:float = 700.0

@onready var player_color = $player_color
var default_beam: String = "red"
var beam_color: String = default_beam


func _ready():
	player_color.color = Color(default_beam)
	


func _physics_process(delta):
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
	if event.is_action_released("fire"):
		GlobalSignalBus.shoot.emit(beam_color)
	elif event.is_action_pressed("blue"):
		beam_color = "blue"
		player_color.color = Color("blue")
	elif event.is_action_pressed("red"):
		beam_color = "red"
		player_color.color = Color("red")
	elif event.is_action_pressed("yellow"):
		beam_color = "yellow"
		player_color.color = Color("yellow")
