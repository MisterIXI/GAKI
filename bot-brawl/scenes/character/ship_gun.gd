@icon("res://assets/icons/cannon.svg")
class_name ShipGun
extends Node2D

@export var loaded_primary: ProjectileSetting
@export var loaded_secondary: ProjectileSetting
@export var available_projectiles: Array[ProjectileSetting]

@onready var ship: SpaceShip = get_parent()

func _ready():
	ship.primary_fire_triggered.connect(on_primary_fire)
	ship.secondary_fire_triggered.connect(on_secondary_fire)

func on_primary_fire():
	if not loaded_primary or not loaded_primary.projectile_scene:
		push_warning("Loaded projectile missing or incorrect, not firing!")
		return
	shoot_shot(loaded_primary)

func on_secondary_fire():
	if not loaded_secondary or not loaded_secondary.projectile_scene:
		push_warning("Loaded projectile missing or incorrect, not firing!")
		return
	shoot_shot(loaded_secondary)

func shoot_shot(settings: ProjectileSetting):
	var new_shot = settings.projectile_scene.instantiate()
	new_shot.global_position = global_position
	new_shot.global_rotation = global_rotation
	if settings.is_laser:
		new_shot.init_laser(settings, ship, ship.linear_velocity)
	else:
		new_shot.init_missile(settings, ship, ship.linear_velocity)
	ship.add_sibling(new_shot)