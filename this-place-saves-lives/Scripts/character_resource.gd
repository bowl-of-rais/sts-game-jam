extends Resource
class_name CharacterSetting

enum Need{
	talk,drugs,relax,socialize,\
	kitchen,shower,toilet,\
	menstrual_hygiene,breastfeed
	}

static var str_to_need = {
	"talk" : Need.talk,
	"drugs" : Need.drugs,
	"relax" : Need.relax,
	"socialize" : Need.socialize,
	"kitchen" : Need.kitchen,
	"shower" : Need.shower,
	"toilet" : Need.toilet,
	"menstrual_hygiene" : Need.menstrual_hygiene,
	"breastfeed" : Need.breastfeed
}

static func need_from_str(s: String) -> Need:
	if s in str_to_need.keys():
		return str_to_need[s]
	return -1
	
enum BodyType{fem_slim, masc_slim, fem_curvy, masc_curvy}

static var str_to_bodytype = {
	"fem_slim" : BodyType.fem_slim,
	"masc_slim" : BodyType.masc_slim,
	"fem_curvy" : BodyType.fem_curvy,
	"masc_curvy" : BodyType.masc_curvy
}

static func bodytype_from_str(s: String) -> BodyType:
	if s in str_to_bodytype.keys():
		return str_to_bodytype[s]
	return -1

@export var name:String
@export var skin:ShaderMaterial
@export var bodytype:BodyType
@export var initial_needs:Array[Need]
@export_range(10, 100) var speed:float 

@export var overdose_risk: int
