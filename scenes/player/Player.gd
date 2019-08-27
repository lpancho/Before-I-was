extends KinematicBody2D

onready var wash_scn = load("res://scenes/wash/Wash.tscn")
onready var dash_skill_t = $DashSkillTimer
onready var invi_skill_t = $InvisibleSkillTimer
onready var wash_skill_t = $WashSkillTimer
onready var invi_t = $InvisibleTimer
onready var start_invi_t = $StartInvisibleTimer
onready var dash_box = $CanvasLayer/HBoxContainer/DashBox
onready var invi_box = $CanvasLayer/HBoxContainer/InvisibleBox
onready var dash_progress = $CanvasLayer/HBoxContainer/DashBox/ProgressBar
onready var invi_progress = $CanvasLayer/HBoxContainer/InvisibleBox/ProgressBar
onready var wash_progress = $CanvasLayer/HBoxContainer/WashBox/ProgressBar
onready var dash_prog_timer = $CanvasLayer/HBoxContainer/DashBox/DashProgTimer
onready var invi_prog_timer = $CanvasLayer/HBoxContainer/InvisibleBox/InviProgTimer
onready var wash_prog_timer = $CanvasLayer/HBoxContainer/WashBox/WashProgTimer
onready var anim = $AnimModulate

var SPEED = 350
var target = Vector2()
var velocity = Vector2()

var DASH_VALUE = 4000
var current_dash_value = 0

signal collided_to_enemy

func _ready():
	dash_box.show()
	invi_box.show()
	
func _physics_process(delta):
	
	var Q = Input.is_action_just_pressed("Q") # DASH
	var W = Input.is_action_just_pressed("W") # INVISIBLE
	var E = Input.is_action_just_pressed("E") # WASH
	
	if Q and dash_skill_t.is_stopped():
		$Dash.play()
		current_dash_value = DASH_VALUE
		dash_skill_t.start()
		dash_prog_timer.start()
	if W and invi_skill_t.is_stopped() and invi_t.is_stopped():
		$Invisible.play()
		set_collision_mask_bit(1, false)
		invi_t.start()
		invi_skill_t.start()
		invi_prog_timer.start()
		anim.play("Invisible")
	if E and wash_skill_t.is_stopped():
		var wash = wash_scn.instance()
		wash.position = $Sprite.offset
		add_child(wash)
		wash_prog_timer.start()
	target = get_global_mouse_position()
	velocity = (target - position).normalized() * (SPEED + current_dash_value)
	if (target - position).length() > 5:
		velocity = move_and_slide(velocity)
	
	# Get collision
	for i in range(get_slide_count() - 1):
		var collision = get_slide_collision(i)
		if "Enemy" in collision.collider.name:
			emit_signal("collided_to_enemy")
	
	if current_dash_value != 0:
		current_dash_value = 0
	pass

func _on_DashSkillTimer_timeout():
	print("dash skill stop")
#	dash_skill_t.stop()
	pass # Replace with function body.

func _on_InvisibleSkillTimer_timeout():
	print("invisible skill stop")
#	invi_skill_t.stop()
	pass # Replace with function body.

func _on_InvisibleTimer_timeout():
	print("invisible stop")
	anim.play_backwards("Invisible")
	set_collision_mask_bit(1, true)
	pass # Replace with function body.

func _on_WashSkillTimer_timeout():
	print("wash skill stop")
	pass # Replace with function body.

func activate_skill(time):
	var TIME_VALUE = 180
	if (TIME_VALUE - time) % 45 == 0:
		if !dash_box.visible:
			dash_box.show()
		elif !invi_box.visible: 
			invi_box.show()

func _on_DashProgTimer_timeout():
	dash_progress.value -= 1
	if dash_progress.value == 0:
		dash_progress.value = dash_progress.max_value
	else:
		dash_prog_timer.start()
	pass # Replace with function body.

func _on_InviProgTimer_timeout():
	invi_progress.value -= 1
	if invi_progress.value == 0:
		invi_progress.value = invi_progress.max_value
	else:
		invi_prog_timer.start()
	pass # Replace with function body.

func _on_WashProgTimer_timeout():
	wash_progress.value -= 1
	if wash_progress.value == 0:
		wash_progress.value = wash_progress.max_value
	else:
		wash_prog_timer.start()
	pass # Replace with function body.

func stop_all():
	set_physics_process(false)
	dash_skill_t.stop()
	invi_skill_t.stop()
	wash_skill_t.stop()
	start_invi_t.stop()
	
	dash_progress.value = dash_progress.max_value
	dash_prog_timer.stop()
	invi_progress.value = invi_progress.max_value
	invi_prog_timer.stop()
	wash_progress.value = wash_progress.max_value
	wash_prog_timer.stop()

func start_invi():
	set_collision_mask_bit(1, false)
	$Invisible.play()
	anim.play("Invisible")
	start_invi_t.start()

func _on_StartInvisibleTimer_timeout():
	set_collision_mask_bit(1, true)
	anim.play_backwards("Invisible")
	pass # Replace with function body.



