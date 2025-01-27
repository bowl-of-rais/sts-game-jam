extends CharacterBody2D

@export var skin:Texture2D:
		get:
			return skin
		set(new_skin):
			skin = new_skin
			%AnimatedSprite2D.material.set_shader_parameter("Skin", new_skin)

@export_enum("fem_slim","masc_slim","fem_curvy","masc_curvy") var bodytype
