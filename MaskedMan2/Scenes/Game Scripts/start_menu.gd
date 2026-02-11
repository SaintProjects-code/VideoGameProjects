extends CanvasLayer

signal start 
signal options 
signal highscore 


func _on_start_button_pressed():
	start.emit()

func _on_options_button_pressed():
	options.emit()
	
func _on_high_score_button_pressed():
	highscore.emit()
