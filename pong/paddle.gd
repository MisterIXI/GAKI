class_name Paddle
extends CharacterBody2D
#-- Die Geschwindigkeit des Paddles. Kann man dank @export pro Instanz einstellen.
## speed of paddle movement
@export var speed: float = 400.0
#-- Normalerweise würde man die Größe direkt auslesen aus CollisionShape2D oder Sprite2D
#-- Hier zu vereinfachung von späteren Code hardcoded
## size of paddle (used for ball calculation later)
const size: float = 120.0
#-- Kann man sich vorstellen wie ein Joystick
#-- Nach unten -1 und nach oben 1
## movement direction: -1.0 down and 1.0 up
var movement: float = 0.0

func _physics_process(delta):
	# If Movement is not zero
	if movement != 0.0:
		velocity.x = 0
		#-- Hier wird zur Sicherheit die movement Variable clamped (min -1 und max 1)
		#-- falls die variable falsch von außen gesetzt wird.
		#-- das wird noch mit _speed_ multipliziert für die richtige Geschwindigkeit.
		# set vertical velocity and clamp movement in case it's set incorrectly
		velocity.y = clampf(movement, -1.0, 1.0) * speed
		#-- move_and_collide hat einen Rückgabewert bei Kollision; wird hier verworfen
		#-- Wir nutzen hier nicht move_and_slide, da wir an der Wand stehen bleiben wollen.
		# move until hitting an obstacle
		move_and_collide(velocity * delta)