extends Area2D

@export var dialogue_resource: DialogueResource

func action() -> void:
	var character = get_parent()
	
	var dialogue_text = character.dialogue_id
	print(dialogue_text)
	
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_text)
