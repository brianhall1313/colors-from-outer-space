extends Node

signal shoot(color:String)
signal invader_death
signal invader_shoot(invader_position:Vector2,color:String)
signal player_death
signal player_damage()
signal explosion(boom_position:Vector2,color:String)
signal toggle_pause
signal update_ui
signal repair
signal rainbow
signal score(points_scored:int)
signal ufo_death(position)

