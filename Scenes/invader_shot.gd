extends Node2D


const SPEED: float = 200.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.current_state=="play" or Global.current_state=="setup":
		position.y += delta*SPEED

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_area_entered(area):
	print("player should get ahead")
	if area.get_parent().has_method("get_hit"):
		area.get_parent().get_hit()
		queue_free()


func _on_area_2d_body_entered(body):
	if body.has_method("get_hit"):
		print("player should get hit")
		body.get_hit()
		queue_free()
