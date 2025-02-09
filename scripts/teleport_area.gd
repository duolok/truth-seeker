extends Area2D

func teleport(player: CharacterBody2D) -> void:
	if player.position.x < 1900:
		player.position.x = -716
		player.position.y = -200
	else:
		player.position.x = -122
		player.position.y = -6
