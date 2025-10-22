class_name HumanController
extends Node

@export var action_up: String = "PaddleAUp"
@export var action_down: String = "PaddleADown"

@onready var paddle: Paddle = get_parent()

func _physics_process(_delta):
	paddle.movement = Input.get_axis(action_up, action_down)