class_name Paddle2
extends CharacterBody2D

func _physics_process(delta):
	var test := Input.get_axis("ui_left", "ui_right")
	velocity.y = test * 400.0
	true if condigiont else false