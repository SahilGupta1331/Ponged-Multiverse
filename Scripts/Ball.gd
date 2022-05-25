extends KinematicBody2D

var dir = Vector2.ZERO
var speed = 50
var type = 'ball'

func _ready():
	visible = false
	Main.p2_power = ''
	Main.p1_power = ''
	$back.stream = load("res://Sounds/"+Main.type+"/song.mp3")
	$point.stream = load("res://Sounds/"+Main.type+"/Ring.wav")
	dir = Vector2(Main.rand_dir(), 0.1).normalized()

func _process(delta):
	if position.x > 180 or position.x < 140:
		visible = true
	if position.x > 320:
		Main.p1_score += 1
		position = Vector2(160, 230)
		dir = Vector2.ZERO
		$point.play()
	elif position.x < 0:
		Main.p2_score += 1
		position = Vector2(160, 230)
		dir = Vector2.ZERO
		$point.play()
	if position.y > 230 or position.y < -10:
		position.y = 112
	move_and_slide(dir*speed, Vector2.ZERO, false, 4, 0.785398, false)
	for i in get_slide_count():
		var col = get_slide_collision(i)
		if col.collider.is_in_group('luigi') and Main.side != '':
			col.collider.apply_central_impulse(-col.normal*100)
			dir = col.normal.round()
	if dir.x == 0: dir.x = 1
	

func _on_Area2D_body_entered(body):
	if body.get('type'):
		if body.type == 'boomerang':
			dir = (global_position-body.global_position).normalized() * 10
			return
		Main.side = body.type
	dir = (global_position-body.global_position).normalized()
	speed += 0.25

func _on_point_finished():
	Main.change_level()

func burn():
	if get_parent().get_node_or_null('Burn') != null:
		get_parent().get_node('Burn').queue_free()
	var burn = preload("res://Scenes/burn.tscn").instance()
	get_parent().add_child(burn)
	burn.global_position.x = global_position.x
	burn.global_position.y = global_position.y - 5
	global_position = Vector2(160,48)
	dir = Vector2(rand_range(-1,1), 0.1).normalized()
