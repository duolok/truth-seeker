extends CharacterBody2D
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@onready var npc: CharacterBody2D = $"."
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@export var dialogue_id: String
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
	var hat_color = npc.get_meta("hat_color")
	#default, red, gree, yellow : 0,1,2,3
	match hat_color:
		0:
			animator.play("default")
		1:
			animator.play("npc_red")
		2:
			animator.play("npc_green")
		3:
			animator.play("npc_yellow")	
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
