extends Sprite2D
func _physics_process(delta):
	position.x += 60 * delta
	print(delta)