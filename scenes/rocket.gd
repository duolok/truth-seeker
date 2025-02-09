extends Sprite2D

@export var character: CharacterBody2D
@export var emission: bool = false
@onready var particles: CPUParticles2D = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if emission:
		particles.emitting = true
	else:
		particles.emitting = false
