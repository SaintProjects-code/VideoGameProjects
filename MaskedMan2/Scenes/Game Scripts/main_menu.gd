extends Node

@export var main_game = PackedScene  
var maskdude_pos := Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_menu_start():
	get_tree().change_scene_to_packed(main_game)

func _on_start_menu_options():
	pass # Replace with function body.

func _on_start_menu_highscore():
	pass # Replace with function body.

func _on_masked_dude_timer_timeout():
	#write a function so that masked dude flys  across screen 
	pass # Replace with function body.
