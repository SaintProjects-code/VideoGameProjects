extends Area2D

signal hit 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= get_parent().scroll_speed + get_parent().lvl_speed * 1.5


func _on_body_entered(body):
	hit.emit()
