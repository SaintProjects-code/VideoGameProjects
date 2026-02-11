extends Node


@export var main = PackedScene




func _on_start_menu_start_game():
	get_tree().change_scene_to_packed(main)
