extends Camera2D

var shake_amount = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport_rect().size
	zoom = screen_size / Vector2(500, 200)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var screen_size = get_viewport_rect().size
	zoom = screen_size / Vector2(16 * 35, 9 * 35)

	if shake_amount > 0:
		shake_amount = max(shake_amount - delta * 5, 0)  # Reduce shake over time
		offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))

func start_shake(amount: float, duration: float):
	shake_amount = amount
	await get_tree().create_timer(duration).timeout
	shake_amount = 0  # Stop shaking
