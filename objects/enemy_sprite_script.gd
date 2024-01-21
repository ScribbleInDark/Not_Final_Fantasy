extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func death_blink(duration):

	hide()
	await get_tree().create_timer(.2).timeout
	show()
	await get_tree().create_timer(.1).timeout
	hide()
	await get_tree().create_timer(.1).timeout
	show()
	await get_tree().create_timer(.2).timeout
	hide()
