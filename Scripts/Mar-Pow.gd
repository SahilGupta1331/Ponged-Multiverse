extends Node2D

export var index = 0
var power
onready var sprite = get_node("power")
var given = false
func _ready():
	$AudioStreamPlayer2D.stream = load("res://Sounds/"+Main.type+"/PowerUP.wav")
	$power.frame = index 
	match index:
		0:
			power = 'big'
		1:
			power = 'small'
		2:
			power = 'invin'
		3:
			power = 'fire'
		4:
			power = 'boomerang'
		7:
			power = 'ze-shield'

func _on_PowerUP_body_entered(body):
	if Main.side != '' and !given:
		$AudioStreamPlayer2D.play()
		if Main.side == 'p1':
			Main.p1_power = power
		if Main.side == 'p2':
			Main.p2_power = power
		visible = false
		given = true
