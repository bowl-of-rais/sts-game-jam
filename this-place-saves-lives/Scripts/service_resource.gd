extends Resource
class_name Services

enum Types {
	Consumption,
	Toilet,
	Shower,
	Couch,
	Kitchen,
	Lounge,
	Menstrual,
	PrivacyScreen
}

static var service_to_need : Dictionary = {
	Types.Consumption : CharacterSetting.Need.drugs,
	Types.Toilet : CharacterSetting.Need.toilet,
	Types.Shower : CharacterSetting.Need.shower,
	Types.Couch : CharacterSetting.Need.relax,
	Types.Kitchen : CharacterSetting.Need.kitchen,
	Types.Lounge : CharacterSetting.Need.socialize,
	Types.Menstrual : CharacterSetting.Need.menstrual_hygiene,
	Types.PrivacyScreen : CharacterSetting.Need.breastfeed
}

static func needs_of(type: Types) -> CharacterSetting.Need:
	return service_to_need[type]

static var service_to_price : Dictionary = {
	Types.Consumption : 500,
	Types.Toilet : 1000,
	Types.Shower : 1000,
	Types.Couch : 500,
	Types.Kitchen : 50,
	Types.Lounge : 500,
	Types.Menstrual : 5,
	Types.PrivacyScreen : 50
}

static func price_of(type: Types) -> CharacterSetting.Need:
	return service_to_price[type]
