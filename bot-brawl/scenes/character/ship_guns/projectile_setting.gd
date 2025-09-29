class_name ProjectileSetting
extends Resource

@export var projectile_scene: PackedScene = null



@export_group("Missile Settings")
@export_custom(PROPERTY_HINT_GROUP_ENABLE,"") var is_missile: bool = false
## fuel duration of missile until it runs out
@export var fuel_duration: float = 5
## Turning speed in degree/seconds
@export var turning_speed: float = 30
@export var boosting_strength: float = 50
## Explosion radius
@export var explosion_radius: float = 50
@export var explosion_damage: float = 15
@export var impact_damage: float = 10

@export_group("Laser Settings")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var is_laser: bool = false
@export var laser_velocity: float = 50
@export var laser_damage: float = 10
@export var laser_energy_cost: float = 5
@export var laser_lifetime: float = 3.0