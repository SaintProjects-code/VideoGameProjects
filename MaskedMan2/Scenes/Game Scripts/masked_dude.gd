extends CharacterBody2D

#masked dude variables 
const gravity : int = 1000 #this is to make maskdude feel gravity so he's alwalys going down
const max_velocity : int = 800 #Max speed going down (limits how fast he falls)
const start_pos = Vector2(150,400) #starting position 
var flying : bool #empty bool to detected when flying or falling 
var falling : bool #^
var flap_speed : int = -500 #how much maskdude will jump when the player left clicks 
var not_jump : bool

#this function is ran when the node first readys up 
func _ready():
	reset()
	
#resets the players game variables (start position, flying/falling bool and the rotation) 
func reset():
	position = start_pos
	flying = false 
	falling = false
	not_jump = true
	set_rotation(0)
	$jumptimer.stop()
	$AnimatedSprite2D.play("Idle")
	
	
func _physics_process(delta):
	if flying or falling:
		velocity.y += gravity * delta
		
		if velocity.y > max_velocity:
			velocity.y = max_velocity
			
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			if not_jump:
				$AnimatedSprite2D.play("Falling")
			else:
				$AnimatedSprite2D.play("Flying")#@@   had a bug where flying had a space at the end so the animation would not run
			
		elif falling:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	
		
func jump():
	velocity.y = flap_speed


func _on_jumptimer_timeout():
	not_jump = true
