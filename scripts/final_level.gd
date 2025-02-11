extends Node2D
@onready var player: CharacterBody2D = $player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_rocket_rocket_launched() -> void:
	player.popup = false

	$AnimationPlayer/cutscene_camera.global_position=$player/player_camera.global_position
	
	$AnimationPlayer/cutscene_camera.zoom=$player/player_camera.zoom
	$AnimationPlayer/cutscene_camera.zoom*=0.6
	$AnimationPlayer.get_animation("launch").track_set_key_value(1,0,$player/player_camera.global_position)

	$AnimationPlayer/cutscene_camera.make_current()
	
	$AnimationPlayer.play("launch")
