extends KinematicBody2D

func _ready():
	$Wash.play()
	$Anim.play("default")
	pass

func _on_Anim_animation_finished(anim_name):
	if anim_name == "default":
		queue_free()
	pass # Replace with function body.
