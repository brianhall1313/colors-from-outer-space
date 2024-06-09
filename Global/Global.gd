extends Node

var color_blind_mode:bool = false
const DEBUG=false

const STATES:Array[String]=["menu","play","setup","dead"]

var current_state:String=""
var previous_state:String=""

func _ready():
	current_state="setup"


func change_state(new_state):
	if new_state in STATES:
		previous_state=current_state
		current_state=new_state
