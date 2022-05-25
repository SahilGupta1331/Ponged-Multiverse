extends Node

var p2_score = 0
var p1_score = 0
var p2_power = ''
var p1_power = ''
var side = ''
var level = 0
var type = ''

func change_level():
	p2_power = ''
	p1_power = ''
	side = ''
	level += 1
	if level > 5:
		level = 1
	get_tree().change_scene("res://Levels/"+type+"/Level-"+str(level)+".tscn")

func rand_dir():
	randomize()
	if rand_range(0,1) > 0.5:
		return 1
	else:
		return -1
