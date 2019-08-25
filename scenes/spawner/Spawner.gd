extends Node2D

const MAX_SPAWN = 60
var spawn_count = 0

var is_spawn_ready = false
signal create_triangle

func _process(delta):
	if is_spawn_ready and spawn_count != MAX_SPAWN:
		spawn()

func spawn():
	$Spawn.play()
	$Timer.start()
	emit_signal("create_triangle", position)
	spawn_count += 1
	is_spawn_ready = false
	get_new_location()

func _on_Timer_timeout():
	is_spawn_ready = true
	pass # Replace with function body.

func get_new_location():
	var offset = 64
	var x = clamp(randi() % int(OS.window_size.x - offset), offset, OS.window_size.x - offset)
	var y = clamp(randi() % int(OS.window_size.y - offset), offset, OS.window_size.y - offset)
	position = Vector2(x, y)

func start():
	spawn_count = 0
	set_process(true)
	$Timer.start()

func stop():
	set_process(false)
	$Timer.stop()