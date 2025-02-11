extends Control

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/intro_level.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
