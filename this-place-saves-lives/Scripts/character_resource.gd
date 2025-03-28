extends Resource
class_name CharacterSetting

enum Need{
	talk,drugs,relax,socialize,\
	kitchen,shower,toilet,\
	menstrual_hygiene,breastfeed
	}

enum BodyType{fem_slim, masc_slim, fem_curvy, masc_curvy}

@export var skin:ShaderMaterial
@export var bodytype:BodyType
@export var initial_needs:Array[Need]
@export_range(10, 100) var speed:float
