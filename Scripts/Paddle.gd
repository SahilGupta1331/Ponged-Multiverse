extends KinematicBody2D

export var type = 'p1'
export var ACC = 1000
export var MAXSPEED = 5000
export var FRIC = 500
export var MAXHEALTH = 0
var score = 0
var power = ''
var vel = Vector2.ZERO
var powerind = 0
onready var health = MAXHEALTH

func _ready():
	$Sprite.frame = 0

func _process(delta):
	if score ==5:
		won()
	var dir = Vector2.ZERO
	$CanvasLayer/Score.text = str(score)
	$CanvasLayer/TextureRect.rect_size = Vector2(9*health, 9)
	if type == 'p1':
		power = Main.p1_power
		score = Main.p1_score
		if Input.is_key_pressed(KEY_W):
			dir = Vector2.UP
		elif Input.is_key_pressed(KEY_S):
			dir = Vector2.DOWN
		if get_global_mouse_position().x < 160 and Input.is_mouse_button_pressed(1):
			if get_global_mouse_position().y > global_position.y:
				dir = Vector2.DOWN
			else:
				dir = Vector2.UP 
	elif type == 'p2':
		power = Main.p2_power
		score = Main.p2_score
		if Input.is_key_pressed(KEY_I):
			dir = Vector2.UP
		elif Input.is_key_pressed(KEY_K):
			dir = Vector2.DOWN
		if get_global_mouse_position().x > 160 and Input.is_mouse_button_pressed(1):
			if get_global_mouse_position().y > global_position.y:
				dir = Vector2.DOWN
			elif get_global_mouse_position().y < global_position.y:
				dir = Vector2.UP 
	if dir.y != 0:
		vel.y += dir.y*ACC*delta
		vel.y = vel.clamped(MAXSPEED*delta).y
	else:
		vel.y = vel.move_toward(Vector2.ZERO, FRIC*delta).y
	vel.y += dir.y*(ACC*2)*delta
	use_power()
	vel=move_and_slide(vel)

func won():
	var won = preload("res://Scenes/Won.tscn").instance()
	won.get_node("AudioStreamPlayer2D").stream = load("res://Sounds/"+Main.type+"/won.mp3")
	$anim.play("won")
	get_tree().paused = true
	get_parent().add_child(won)
	won.get_node("RichTextLabel").text = type.capitalize()+' WINS!'

func use_power():
	match power:
		'speed':
			MAXSPEED = 50000
			ACC = 2500
			FRIC = 5000
		'shield':
			if get_node_or_null('Shield') == null:
				var shield = preload("res://Scenes/So-Shield.tscn").instance()
				add_child(shield)
		'swim':
			if get_node_or_null('Shield') == null:
				var shield = preload("res://Scenes/So-Shield.tscn").instance()
				add_child(shield)
		'invin':
			if get_node_or_null('Invin') == null:
				var invin = preload("res://Scenes/Invin.tscn").instance()
				invin.get_node("AudioStreamPlayer2D").stream = load("res://Sounds/"+Main.type+"/Invin.mp3")
				add_child(invin)
		'big':
			scale = Vector2(10,10)
			ACC = 100
			MAXSPEED = 500
			FRIC = 50
		'small':
			scale = Vector2(1,1)
			ACC = 1000
			MAXSPEED = 5000
			FRIC = 500
		'fire':
			var moup = get_global_mouse_position()
			modulate = Color(1,0,0,1)
			if Input.is_action_just_pressed(type+"pow") or (Input.is_action_just_released('moup') and ((moup.x < global_position.x+8)and(global_position.x-8 < moup.x)) and ((moup.y > global_position.y-16) and (moup.y < global_position.y+16))):
				var ball = preload("res://Scenes/Fireball.tscn").instance()
				ball.global_position = global_position
				ball.side = type
				owner.add_child(ball)
		'boomerang':
			if owner.get_node_or_null('Boomerang') == null:
				var moup = get_global_mouse_position()
				if get_node_or_null('boom') == null:
					var boom = Sprite.new()
					boom.texture = preload("res://Sprites/boomerang.png")
					boom.name = 'boom'
					add_child(boom)
					move_child(boom, 0)
				if Input.is_action_just_pressed(type+"pow") or (Input.is_action_just_released('moup') and ((moup.x < global_position.x+8)and(global_position.x-8 < moup.x)) and ((moup.y > global_position.y-16) and (moup.y < global_position.y+16))):
					$boom.queue_free()
					var ball = preload("res://Scenes/Boomerang.tscn").instance()
					ball.global_position = global_position
					ball.side = type
					owner.add_child(ball)
		'ze-shield':
			if get_node_or_null('shield') == null:
				var boom = Sprite.new()
				boom.texture = preload("res://Sprites/ze-shield.png")
				boom.name = 'shield'
				boom.scale = Vector2(0.5,0.5)
				boom.position.x = 2
				if type == 'p2':
					boom.flip_h = true
					boom.position.x = -2
				add_child(boom)

func break_shield():
	remove_child(get_node("Shield"))
	power = ''
	$anim.play("hurt")

func drown():
	$Timer.start()

func hurt(n):
	if power == 'invin' or power == 'swim' or power == 'ze-shield':
		pass
	elif health == 0:
		die()
	else:
		health -= n
		$anim.play("hurt")
		if health == 0:
			die()

func die():
	if power == '':
		$anim.play("die")
	elif power == 'shield':
		break_shield()
	elif power == 'invin' or power == 'swim' or power == 'ze-shield':
		pass

func _on_Timer_timeout():
	die()
