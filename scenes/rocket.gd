extends Sprite2D

@export var character: CharacterBody2D
@export var emission: bool = false
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var label: Label = $Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if emission:
		particles.emitting = true
	else:
		particles.emitting = false

	
func _on_area_2d_body_entered(body: Node2D) -> void:
	label.show()


func _on_area_2d_body_exited(body: Node2D) -> void: 
	label.hide()
