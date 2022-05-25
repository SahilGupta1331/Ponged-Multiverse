extends KinematicBody2D

func _on_Area2D_body_entered(body):
	if body.type == 'p1' or body.type == 'p2':
		body.die()
