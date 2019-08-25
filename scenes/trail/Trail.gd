extends Node

onready var line = $Line2D
var trail_length = 15
export(Color) var color
var point

func _ready():
	line.default_color = color

func _process(delta):
	point = get_parent().global_position
	line.add_point(point)
	if line.points.size() > trail_length:
		line.remove_point(0)
	pass
