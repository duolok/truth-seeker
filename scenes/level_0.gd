extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if Input.is_action_pressed("ui_dialogue"):
		#
		#$AnimationPlayer/cutscene_camera.global_position=$player/Camera2D.global_position
		#
		#$AnimationPlayer/cutscene_camera.zoom=$player/Camera2D.zoom
#
		#$AnimationPlayer/cutscene_camera.make_current()
		#$AnimationPlayer.get_animation("launch").track_set_key_value(0,0,$AnimationPlayer/cutscene_camera.position)
		#
		#$AnimationPlayer.play("launch")
	pass
		
		
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/level1.tscn")
		
