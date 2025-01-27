@tool
extends EditorScript

var skin_key = load("res://Assets/Topdown/Animations/CharacterSkinKey.png")
var raw_image:Image
var mapped_image:Image

func _run() -> void:
	assert(skin_key.has_method("get_pixel"))
	assert(check_key(), "The skin_key should contain a unique color for every pixel!")


func load_raw_image(path:String):
	pass

##checks if every pixel in the key is unique and therefore valid
func check_key()->bool:
	var found_colors = []
	for x in skin_key.get_width():
		for y in skin_key.get_height():
			var color = skin_key.get_pixel(x,y)
			if color.a == 0.0: break
			color.a = 1.0 #set alpha to default to ignore it for comparison
			if found_colors.has(color): return false
			found_colors.append(color)
	return true

##takes a path to an image and mapps it according to the skin_key
func map_sprite_sheet(raw_image:Image):
	mapped_image =  Image.create_empty(\
		raw_image.get_width(),raw_image.get_height(),\
		false,raw_image.Format)
	for x in skin_key.get_width():
		for y in skin_key.get_height():
			color_to_key_position(x,y,skin_key.get_pixel(x,y))

##takes a pixels color and its position
##and replaces that color in the sprite_sheet with an encoding of that position
func color_to_key_position(x, y, target_color:Color):
	for u in raw_image.get_width():
		for v in raw_image.get_height():
			var color = raw_image.get_pixel(u,v)
			if color.r == target_color.r \
			and color.g == target_color.g \
			and color.b == target_color.b:
				mapped_image.set_pixel(u,v,Color(x,y,color.b,color.a*raw_image.a))
