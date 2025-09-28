extends Sprite2D

var tween: Tween

func _ready():
	get_parent().thrusting_changed.connect(on_is_boosting_changed)
	modulate = Color.TRANSPARENT
	

func on_is_boosting_changed(is_boosting: bool) -> void:
	if tween:
		tween.kill()
	if is_boosting:
		tween = create_tween()
		tween.set_loops()
		tween.tween_property(self, "modulate", Color.WHITE, 0.3)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0.5), 0.3)
	else:
		tween = create_tween()
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)