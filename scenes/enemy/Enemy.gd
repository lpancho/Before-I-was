extends KinematicBody2D

const SPEED = 250

const CHANGE_DIRECTION_TIMER = 30
var current_change_direction_timer = 0
var target = Vector2()
var velocity = Vector2()

signal collided_to_player

func _ready():
	randomize()
	get_new_location()
	$AnimRotate.play("default")

func _physics_process(delta):
	if ((target - position).length() < 5 and current_change_direction_timer == 0) or is_on_wall():
		get_new_location()
		current_change_direction_timer = CHANGE_DIRECTION_TIMER
		
	velocity = (target - position).normalized() * SPEED
	if (target - position).length() > 5:
		velocity = move_and_slide(velocity)
	
	# Get collision
	for i in range(get_slide_count() - 1):
		var collision = get_slide_collision(i)
		if "Player" in collision.collider.name:
			emit_signal("collided_to_player")
		
	if current_change_direction_timer != 0:
		current_change_direction_timer -= 1

func get_new_location():
	var x = clamp(randi() % int(OS.window_size.x - 32), 32, OS.window_size.x - 32)
	var y = clamp(randi() % int(OS.window_size.y - 32), 32, OS.window_size.y - 32)
	target = Vector2(x, y)