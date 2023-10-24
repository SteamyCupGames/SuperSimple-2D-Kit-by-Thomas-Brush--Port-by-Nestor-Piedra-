extends Line2D

var point = Vector2()
@export var MAX_LENGTH : int

func _process(_delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	
	point = get_parent().global_position
	
	add_point(point)
	while get_point_count() > MAX_LENGTH:
		remove_point(0)
