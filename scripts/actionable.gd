extends Area2D

@export var dialogue_resource: DialogueResource
var is_dialogue_active = false  

func _ready():
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)  

func action() -> void:
	if is_dialogue_active:
		return  

	var character = get_parent()
	var dialogue_text = character.dialogue_id
	print(dialogue_text)

	is_dialogue_active = true  
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_text)

func _on_dialogue_ended(resource: DialogueResource):
	if resource == dialogue_resource:  
		is_dialogue_active = false  
