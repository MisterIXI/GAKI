extends Sprite2D

var tween: Tween
@onready var smoke_particles: CPUParticles2D = $ExhaustSmoke

func _ready():
	get_parent().thrusting_changed.connect(on_is_boosting_changed)
	modulate = Color.TRANSPARENT
	smoke_particles.scale_amount_min *= scale.x
	smoke_particles.scale_amount_max *= scale.x
	smoke_particles.emitting = false
	

func on_is_boosting_changed(is_boosting: bool) -> void:
	if tween:
		tween.kill()
	if is_boosting:
		tween = create_tween()
		tween.set_loops()
		tween.tween_property(self, "modulate", Color.WHITE, 0.3)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0.5), 0.3)
		smoke_particles.emitting = true
	else:
		tween = create_tween()
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
		smoke_particles.emitting = false