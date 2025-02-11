extends Node2D

@onready var left: Label = $left
@onready var middle: Label = $middle
@onready var right: Label = $right
@onready var rocket: Sprite2D = $"../.."
@onready var canvas_layer: CanvasLayer = $".."

var left_num = 0
var middle_num = 0
var right_num = 0
var passkey = 1000

func _ready() -> void:
	passkey = rocket.get_meta("password")

func button_press(num: String) -> void:
	match num:
		"1":
			left_num=(left_num+1)%10
			left.text = str(left_num)
		"3":
			middle_num=(middle_num+1)%10
			middle.text = str(middle_num)
		"2":
			right_num=(right_num+1)%10
			right.text = str(right_num)
		"4":
			left_num=(left_num+9)%10
			left.text = str(left_num)
		"6":
			middle_num=(middle_num+9)%10
			middle.text = str(middle_num)
		"5":
			right_num=(right_num+9)%10
			right.text = str(right_num)
	
		
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_enter"):
		if passkey == left_num*100+middle_num*10+right_num:
			canvas_layer.visible = false
			rocket.start_launch_animation()
