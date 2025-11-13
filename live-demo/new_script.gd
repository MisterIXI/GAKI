extends Node
@export var external_mat: ShaderMaterial
@export var my_image: Image

func _ready():
	
	var mat: ShaderMaterial = external_mat
	mat.set_shader_parameter("color", Color.RED)
	mat.set_shader_parameter("amount", 0.73)
	mat.set_shader_parameter("other_color", Color.BLUE)
	mat.set_shader_parameter("image", my_image)
