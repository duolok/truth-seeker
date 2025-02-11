extends Sprite2D

@export var character: CharacterBody2D
@export var emission: bool = false

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var label: Label = $Label
@onready var launch_camera: Camera2D = $launch_camera
@onready var rocket :Node2D = $"."
@onready var player_camera=get_parent().find_child("player").get_node("player_camera")

var rng=RandomNumberGenerator.new()


signal rocket_launched

func _ready() -> void:
	connect("start_liftof", Callable(self, "_on_my_custom_signal"))
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


	
func start_launch_animation():
	
	var launch_camera_pos=launch_camera.global_position


	var tween=create_tween()
	
	if(get_parent().name=="FinalLevel"):
		tween.tween_callback(on_launched)
		return

	launch_camera.top_level=true
	
	launch_camera.global_position=player_camera.global_position
	launch_camera.zoom=player_camera.zoom

	
	launch_camera.make_current()
	
	tween.tween_property(launch_camera,"position",launch_camera_pos,1.6)
	tween.tween_interval(0.5)
	tween.tween_interval(1.5)
	tween.parallel().tween_method(shake,6.0,6.0,1.5)
	tween.tween_property(rocket,"position",rocket.global_position-Vector2(0,1000),3.0)
	tween.parallel().tween_method(shake,6.0,0,3.0)
	tween.parallel().tween_property(rocket, "emission", true, 0.0)

	tween.tween_callback(on_launched)
	
func shake(shake_strength):
	launch_camera.offset=Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))

func on_launched():
	rocket_launched.emit()
