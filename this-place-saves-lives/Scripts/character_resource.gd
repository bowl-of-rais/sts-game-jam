extends Resource
class_name CharacterSetting

@export var skin:Texture2D
@export_enum("fem_slim","masc_slim","fem_curvy","masc_curvy") var bodytype

enum needs{talk,drugs,relax,kitchen,toilet,\
shower,menstrual_hygiene,breastfeed}
@export var current_needs:Array[needs]
