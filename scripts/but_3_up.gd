extends TextureButton

@onready var Pass: Node2D = $".."

func _on_pressed() -> void:
	Pass.button_press("3")
