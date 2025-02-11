extends Node2D
@onready var player: CharacterBody2D = $player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

		


func _on_rocket_rocket_launched() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/first_level.tscn")
