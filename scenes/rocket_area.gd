extends Area2D

var w = 0
var h = 0

@onready var Pass: Node2D = $"../CanvasLayer/pass"
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@export var character: CharacterBody2D 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)	
	character = get_parent().character

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  # Check if the colliding body is the player
		print("Player entered!")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var screen_size = get_viewport_rect().size
	if w != screen_size.x*0.9 or h != screen_size.y*0.9:
		w=screen_size.x*0.9
		h=screen_size.y*0.9
		if w < 1500:
			Pass.scale.x = 3
			Pass.scale.y = 3
		elif w < 2800:
			Pass.scale.x = 7
			Pass.scale.y = 7
		else:
			Pass.scale.x = 9
			Pass.scale.y = 9
			
		Pass.position.x=screen_size.x/2
		Pass.position.y=screen_size.y/2
	
	
func popup() -> void:
	canvas_layer.visible=true
