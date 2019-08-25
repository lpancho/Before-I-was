extends Node2D

onready var triangle_scn = load("res://scenes/enemy/Enemy.tscn")

onready var player = $Player
onready var spawner = $Spawner
onready var time_progress = $TimeProgress
onready var menu_container = $CanvasLayer/MenuContainer
onready var message = $CanvasLayer/MenuContainer/VBoxContainer/LabelMessage

func _ready():
	message.text = "EVERYBODY CAN CHANGE"
	menu_container.show()
	
	player.visible = false
	spawner.visible = false
	player.set_physics_process(false)
	player.connect("collided_to_enemy", self, "_on_Collided_To_Enemy")
	spawner.connect("create_triangle", self, "_on_Create_Triangle")
	
	$BackgroundMusic.play()
	pass

func _process(delta):
	if time_progress.time == 0:
		message.text = "CONGRATULATIONS, YOU HAVE COMPLETED THE CHALLENGE!"
		stop_all()

func _on_Start_pressed():
	start_game()
	pass # Replace with function body.

func _on_Create_Triangle(position):
	var triangle = triangle_scn.instance()
	triangle.position = position
	triangle.connect("collided_to_player", self, "_on_Collided_To_Player")
	add_child(triangle)

func _on_Collided_To_Player():
	defeated()

func _on_Collided_To_Enemy():
	defeated()

func _on_Restart_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_Menu_pressed():
	menu_container.show()
	pass # Replace with function body.

func start_game():
	
	for node in get_tree().get_nodes_in_group("ENEMY"):
		node.queue_free()
	
	menu_container.hide()
	player.visible = true
	spawner.visible = true
	
	player.set_physics_process(true)
	player.start_invi()
	spawner.start()
	time_progress.start()

func defeated():
	var player_time = 180 - time_progress.time
	var minutes = player_time / 60
	var seconds = player_time % 60
	var text = "%02d : %02d" % [minutes, seconds]
	print(text)
	message.text = "AS ALWAYS, YOU CAN TRY AGAIN."
	stop_all()
	
func stop_all():
	player.visible = false
	spawner.visible = false
	player.stop_all()
	spawner.stop()
	time_progress.stop()
	
	for node in get_tree().get_nodes_in_group("ENEMY"):
		node.set_physics_process(false)
	
	menu_container.show()

func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
