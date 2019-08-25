extends ProgressBar

onready var timer = $Timer
onready var label = $TimeLabel

const MAX_TIME = 180
var time = MAX_TIME # total seconds

func _ready():
	pass

func _on_Timer_timeout():
	if time != 0:
		time -= 1
		var minutes = time / 60
		var seconds = time % 60
		label.text = "%02d : %02d" % [minutes, seconds]
		
		value = time
		
		timer.start()
	pass # Replace with function body.

func start():
	time = MAX_TIME
	timer.start()

func stop():
	timer.stop()