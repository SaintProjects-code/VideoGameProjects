extends Node

@export var tree_scene : PackedScene 
@export var saw_scene : PackedScene
@export var platform_scene : PackedScene

#game Variables 
var game_running : bool 
var game_over : bool 
var score 
var scroll : float #to mimic scrolling this number is added to the x-axis 
const scroll_speed = 6
var lvl_speed = 3  ##DONT FORGET TO SET THIS 
#screen var 
var screen_size : Vector2i
var ground_height : int 

#tree and saw variables 
var trees : Array 
const TREE_DELAY : int = 500
var Tree_range_types := [150, 100, 50] #different heights for the trees 
const saw_heights := [500, 400, 200, 300, 450] #different heights for saw 
var obstacles : Array 
var last_saw
const platform_pos := Vector2(0,335)
var platform_a : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	
func new_game():
	game_running = false
	game_over = false
	scroll = 0
	score = 00 
	get_tree().call_group("Obs", "queue_free")
	$MaskedDude.reset()
	$Hub/Score_label.text = "Score: " + str(score)
	$Game_over_hub.hide()
	summon_platform()
	$Hub/start_label.show()
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	for tree in trees:
		tree.queue_free()
	trees.clear()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#code handle scorolling
	if game_running:
		scroll += scroll_speed + lvl_speed
	
		if scroll >= screen_size.x:
			scroll = 0
		
		$Ground.position.x = -scroll
		
		for tree in trees:
			tree.position.x -= scroll_speed + lvl_speed
			
		for i in platform_a:
			i.position.x -= scroll_speed + lvl_speed
			
func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
					$Hub/start_label.hide()
					$MaskedDude/jumptimer.start()
				else:
					if $MaskedDude.flying:
						$MaskedDude/jumptimer.stop()
						$MaskedDude.jump()
						$MaskedDude/jumptimer.start()
						$MaskedDude.not_jump = false
						check_top()
						
func check_top():
	if $MaskedDude.position.y < 0:
		$MaskedDude.falling = true 
		stop_game() 

func start_game():
	game_running = true
	$MaskedDude.flying = true
	$MaskedDude.jump()
	$treetimer.start()
	$MaskedDude.not_jump = false

func generate_saw():
	#created the saw 
	var saw = saw_scene.instantiate()
	var saw_height = saw_heights[randi() % saw_heights.size()]
	saw.position.x = screen_size.x
	saw.position.y = (screen_size.y - ground_height) - saw_height
	saw.hit.connect(player_hit)
	last_saw = saw
	add_child(saw)
	obstacles.append(saw)

func generate_tree():
	#creates a copy of the tree scene 
	var tree = tree_scene.instantiate()
	tree.position.x = screen_size.x + TREE_DELAY
	var Tree_range = Tree_range_types[randi() % Tree_range_types.size()]
	tree.position.y = (screen_size.y - ground_height) - Tree_range
	tree.hit.connect(player_hit)
	tree.score.connect(scored)
	add_child(tree)
	trees.append(tree)

func player_hit():
	$MaskedDude.falling = true
	stop_game()
	
func stop_game():
	game_over = true
	game_running = false 
	$MaskedDude.flying = false
	$treetimer.stop()
	$MaskedDude/AnimatedSprite2D.stop()
	$Game_over_hub.show()
	
func scored():
	score += 1
	$Hub/Score_label.text = "Score: " + str(score)
	
func summon_platform():
	var platform = platform_scene.instantiate()
	platform.position.x = platform_pos.x + scroll_speed
	platform.position.y = platform_pos.y 
	add_child(platform)
	platform_a.append(platform)
	
func _on_treetimer_timeout():
	generate_tree()
	if score >= 5:
		lvl_speed + 1
		generate_saw()
	elif score >= 15:
		lvl_speed + 3
		generate_saw()

	
func _on_ground_hit():
	$MaskedDude.falling = false
	stop_game()


func _on_game_over_hub_restart():
	new_game()
