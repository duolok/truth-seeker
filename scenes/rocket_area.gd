extends Area2D

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
	pass
	
	
func action() -> void:
	character.visible = false
