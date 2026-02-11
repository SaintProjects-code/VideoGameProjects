extends Node

@export var snake_scene : PackedScene

#game variables 
var score : int 
var game_started : bool = false 

#snake variables 
var snake : Array
var snake_data : Array
var old_data : Array

#food_variables 
var regen_food : bool 
var food_pos : Vector2

#grid variable 
var cells = 13
var cells_size = 50 
var screen_size : Vector2

#move variables 
var start_pos = Vector2(9,5)
var can_move : bool 
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1, 0)
var right = Vector2(1, 0)
var move_dir : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	
func new_game():
	$GameOverHub.hide()
	move_dir = up 
	can_move = true 
	regen_food = true
	score = 0 
	$Hub.get_node("Score_label").text = "Score: " + str(score)
	get_tree().call_group("obj", "queue_free")
	generate_snake()
	move_food()
	
func start_game():
	#starts the game by starting the timer and sets game_started to true 
	game_started = true
	$MoveTimer.start()

func generate_snake():
	#clears the position arrays 
	old_data.clear()
	snake.clear()
	snake_data.clear()
	
	#creates the first 3 snake segments 
	for i in range(3):
		add_seg(start_pos + Vector2(0,i))

func add_seg(pos):
	#add the snake segments 
	var snake_seg = snake_scene.instantiate()
	#add the position of the segments to the old_data and snake_data array 
	old_data.append(pos)
	snake_data.append(pos)
	snake_seg.position = (pos * cells_size) #this might need [+ Vector2(0, cell_size)]
	#adds new segment to the scene 
	add_child(snake_seg)
	snake.append(snake_seg)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_snake() 
	
func move_snake():
	#checks to see if the can move variable is true then moves the snake 
	if can_move:
		if Input.is_action_just_pressed("move_down") and move_dir != up:
			move_dir = down
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_up") and move_dir != down:
			move_dir = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_left") and move_dir != right:
			move_dir = left
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("move_right") and move_dir != left:
			move_dir = right
			can_move = false
			if not game_started:
				start_game()

func _on_move_timer_timeout():
	#at the end of the timer changes the can_move variable to true 
	can_move = true
	#add the snake position to the old_data array and snake_data array 
	old_data = [] + snake_data
	snake_data[0] += move_dir #moves head 
	#changes the position of the snake as it moves 
	for i in range(len(snake_data)):
		if i > 0: #moves rest of the body 
			snake_data[i] = old_data[i-1]
		snake[i].position = (snake_data[i] * cells_size) #sets snakes postions
		
	check_bound()
	check_food()
	check_self_eat()
	
func check_bound():
#loops through the snake data to check if it passes the x and y limits of the bounds 
	if snake_data[0].x < 0:
		snake_data[0].x = cells 
	elif snake_data[0].x > cells:
		snake_data[0].x = 0
	if snake_data[0].y < 0:
		snake_data[0].y = cells 
	elif snake_data[0].y > cells:
		snake_data[0].y = 0
		
func check_food():
	if snake_data[0] == food_pos:
		score += 1
		$Hub.get_node("Score_label").text = "Score: " + str(score)
		add_seg(old_data[-1])
		move_food()
	
func check_self_eat():
	#goes through the snake_data to see if the snake overlaps then ends the game 
	for i in range(1, len(snake_data)):
		if snake_data[0] == snake_data[i]:
			end_game()
		
func move_food():
	while regen_food:
		food_pos = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		regen_food = false
		for i in snake_data:
			if food_pos == i:
				regen_food = true
	$masked_Dude_food.play("Idle")
	$masked_Dude_food.position = (food_pos * cells_size) + Vector2(25, 25)
	regen_food = true
	
func end_game():
	game_started = false
	$GameOverHub.show()
	$MoveTimer.stop()

func _on_game_over_hub_restart():
	new_game()
