extends Resource
class_name Services

enum Types {
	Reception,
	Consumption,
	Toilet,
	Shower,
	Couch,
	Cooking,
	Lounge,
	Menstrual,
	PrivacyScreen,
	Snack
}

static var service_to_need : Dictionary = {
	Types.Reception : CharacterSetting.Need.talk,
	Types.Consumption : CharacterSetting.Need.drugs,
	Types.Toilet : CharacterSetting.Need.toilet,
	Types.Shower : CharacterSetting.Need.shower,
	Types.Couch : CharacterSetting.Need.relax,
	Types.Cooking : CharacterSetting.Need.kitchen,
	Types.Lounge : CharacterSetting.Need.socialize,
	Types.Menstrual : CharacterSetting.Need.menstrual_hygiene,
	Types.PrivacyScreen : CharacterSetting.Need.breastfeed,
	Types.Snack : CharacterSetting.Need.kitchen,
}

static func needs_of(type: Types) -> CharacterSetting.Need:
	return service_to_need[type]

static var service_to_price : Dictionary = {
	Types.Reception : 0,
	Types.Consumption : 500,
	Types.Toilet : 1000,
	Types.Shower : 1000,
	Types.Couch : 500,
	Types.Cooking : 50,
	Types.Lounge : 500,
	Types.Menstrual : 5,
	Types.PrivacyScreen : 50,
	Types.Snack : 3
}

static func price_of(type: Types) -> CharacterSetting.Need:
	return service_to_price[type]

static var service_to_texture_path : Dictionary = {
	Types.Reception : "res://Assets/Topdown/static/receptionDesk.png",
	Types.Consumption : "res://Assets/Topdown/static/ConsumptionTable.png",
	Types.Toilet : "res://Assets/Topdown/static/ToiletDoorOpen.png",
	Types.Shower : "res://Assets/Topdown/static/ShowerDoorOpen.png",
	Types.Couch : "res://Assets/Topdown/static/Couch.png",
	Types.Cooking : "res://Assets/Topdown/static/Microwave.png",
	Types.Lounge : "res://Assets/Topdown/static/LoungeTableSet.png",
	Types.Menstrual : "res://Assets/Topdown/static/Tampons.png",
	Types.PrivacyScreen : "res://Assets/Topdown/static/PrivacyScreen.png",
	Types.Snack : "res://Assets/Topdown/static/Cookies.png"
}

static func texture_path_of(type: Types) -> String:
	return service_to_texture_path[type]
	
static var service_to_tooltip_text : Dictionary = {
	Types.Reception : "Reception: not just for paperwork, but also a place to have a little chat.",
	Types.Consumption : "Consumption table: easy to clean and robust",
	Types.Toilet : "Toilet: this should be obvious. Sinks are included",
	Types.Shower : "Shower: to get clean",
	Types.Couch : "Couch: offers a place to relax and hang out",
	Types.Cooking : "Microwave: because everyone deserves a warm meal",
	Types.Lounge : "Lounge table: to sit down, maybe rest with a cup of tea",
	Types.Menstrual : "Menstrual products: not obvious to some, but high in demand",
	Types.PrivacyScreen : "Privacy Screen: barebones, but blocks vision at least",
	Types.Snack : "Snacks: both convenient and calorically dense"
}

static func tooltip_text_of(type: Types) -> String:
	return service_to_tooltip_text[type]
