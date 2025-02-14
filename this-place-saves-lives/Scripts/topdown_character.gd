@tool
extends CharacterBody2D
class_name topdown_character

@export var character:CharacterSetting:
	set(new_settings):
		character = new_settings
		%Sprite.material.set_instance_shader_parameter("skin",new_settings.skin)
	get():
		return self.character

const default_skin = preload("res://Assets/Topdown/Skins/CharacterMapKey.png")

var stateM: StateMachine
var current_needs: Array[CharacterSetting.Need]

func _ready() -> void:
	if not Engine.is_editor_hint():#only execute when game running
		stateM = StateMachine.new()
		stateM.add_state("Idle", idle)
		stateM.set_state("Idle")

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():#only execute when game running
		stateM.process()

func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():#only execute when game running
		pass# move_and_slide towards walking target


func _on_property_list_changed() -> void:
	if self.character != null:
		%Sprite.material.set_instance_shader_parameter("skin",self.character.skin)
	else:
		%Sprite.material.set_instance_shader_parameter("skin",self.default_skin)

func idle():
	pass
	#TODO check current needs
	#TODO request matching service+station
	#TODO calculate route
	#TODO transition to walking
	
func walking():
	pass
