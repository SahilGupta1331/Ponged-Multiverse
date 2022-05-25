extends Node2D

export var index = 0
var power
onready var sprite = get_node("sprite")

func _ready():
	$power.frame = index 
	match index:
		0:
			power = 'speed'
		1:
			power = 'shield'
		2:
			power = 'invin'
		3:
			power = 'swim'

func _on_Area2D_body_entered(body):
	if Main.side != '':
		$sprite.animation = 'broken'
		$anim.play("broken")
		$AudioStreamPlayer2D.play()
		if Main.side == 'p1':
			Main.p1_power = power
		if Main.side == 'p2':
			Main.p2_power = power
		self.remove_child(sprite)
		get_parent().add_child(sprite)
		sprite.global_position = global_position
		sprite.z_index = -1
