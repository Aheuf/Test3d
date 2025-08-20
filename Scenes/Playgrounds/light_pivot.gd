extends Node3D

@export var rotation_speed: float = 1.0  # vitesse de rotation (radians/sec)

func _process(delta: float) -> void:
	# Tourne autour de l’axe Y (vertical)
	rotate_y(rotation_speed * delta)
