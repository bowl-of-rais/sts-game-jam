@tool
extends CharacterBody2D

@export var character:CharacterSetting:
	set(new_settings):
		character = new_settings
		%Sprite.material.set_instance_shader_parameter("skin",new_settings.skin)
	get():
		return self.character

const default_skin = preload("res://Assets/Topdown/Skins/CharacterMapKey.png")

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():#only execute when game running
		pass

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():#only execute when game running
		pass


func _on_property_list_changed() -> void:
	if self.character != null:
		%Sprite.material.set_instance_shader_parameter("skin",self.character.skin)
	else:
		%Sprite.material.set_instance_shader_parameter("skin",self.default_skin)
