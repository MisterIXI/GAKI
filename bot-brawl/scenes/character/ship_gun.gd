class_name ShipGun
extends Node2D

@export var loaded_projectile: ProjectileSetting
@export var available_projectiles: Array[ProjectileSetting]

func _ready():
	var ship_parent: PlayerShip = get_parent()
	ship_parent.laserguns_triggered.connect(on_laserguns_triggered)
	ship_parent.missiles_triggered.connect(on_missiles_triggered)



func on_laserguns_triggered():
	if not loaded_projectile or not loaded_projectile.projectile_scene:
		push_warning("Loaded projectile missing or incorrect, not firing!")
		return
	pass

func on_missiles_triggered(): 
	pass