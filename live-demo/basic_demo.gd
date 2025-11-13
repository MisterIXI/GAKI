extends Sprite2D
const img_size: float = 15.0
func _ready():
	var img := Image.create(img_size,img_size, false, Image.FORMAT_RGBA8)
	
	for y in range(img_size):
		for x in range(img_size):
			img.set_pixel(x,y, Color(x/img_size, y/img_size, 0))
	
	var tex := ImageTexture.create_from_image(img)
	texture = tex
	# img.save_png("res://xy_demo.png")
