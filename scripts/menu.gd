extends Control

@onready var backgroun_image: TextureRect = $BackgrounImage
@onready var main_menu: VBoxContainer = $MainMenu
@onready var back_button: Button = $BackButton
@onready var controls_menu: ScrollContainer = $ControlsMenu
@export var is_in_game: bool = true
@onready var resume: Button = $MainMenu/Resume

func _ready() -> void:
	if is_in_game:
		backgroun_image.visible = false 
		resume.visible = true

func _on_resume_button_pressed() -> void:
	visible = false

func _process(delta: float) -> void:
	pass

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/intro_level.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	main_menu.visible = !main_menu.visible
	controls_menu.visible = !controls_menu.visible
	back_button.visible = !back_button.visible


func _on_back_button_pressed() -> void:
	controls_menu.visible = !controls_menu.visible
	back_button.visible = !back_button.visible
	main_menu.visible = !main_menu.visible
