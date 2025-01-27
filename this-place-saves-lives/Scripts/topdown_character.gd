extends CharacterBody2D

@export var character:CharacterSetting:
	set(new_settings):
		character = new_settings
		%Sprite.material.set_shader_parameter("skin",new_settings.skin)

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass
