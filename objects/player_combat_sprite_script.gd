extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attack_left(duration, step_distance = 8):

	$Sprite.move_local_x(-step_distance)
	await get_tree().create_timer(duration).timeout
	$Sprite.move_local_x(step_distance)
