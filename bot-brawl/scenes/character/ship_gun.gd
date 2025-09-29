class_name ShipGun
extends Node2D

@export var loaded_projectile: ProjectileSetting
@export var available_projectiles: Array[ProjectileSetting]

@onready var ship: RigidBody2D = get_parent()

func _ready():
	ship.laserguns_triggered.connect(on_laserguns_triggered)
	ship.missiles_triggered.connect(on_missiles_triggered)



func on_laserguns_triggered():
	if not loaded_projectile or not loaded_projectile.projectile_scene:
		push_warning("Loaded projectile missing or incorrect, not firing!")
		return
	var new_shot : LaserShot = loaded_projectile.projectile_scene.instantiate()
	new_shot.global_position = global_position
	new_shot.global_rotation = global_rotation
	new_shot.init_laser(loaded_projectile, ship.linear_velocity)
	ship.add_sibling(new_shot)
	print("pew pew")

func on_missiles_triggered(): 
	pass