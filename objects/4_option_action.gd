extends Node2D

var MAX_OPTION = 4
var current_select = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	setup_text(["a","b","3","4"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	"""
	if Input.is_action_just_pressed("ui_down"):
		menu_down()
	elif Input.is_action_just_pressed("ui_up"):
		menu_up()
	"""

func setup_text(text_list):
	for index in range(MAX_OPTION):
		$label_node.get_child(index).hide()
		$select_sprite.get_child(index).hide()
	
	var count = 0
	for text in text_list:
		var label = $label_node.get_child(count)
		label.text = text
		label.show()
		count += 1
	
	$select_sprite.get_child(0).show()
	

func menu_down():
	$select_sprite.get_child(current_select).hide()
	current_select += 1
	
	if current_select >= MAX_OPTION:
		current_select = 0
	elif not $label_node.get_child(current_select).visible:
		current_select = 0
	
	$select_sprite.get_child(current_select).show()
	
	
func menu_up():
	$select_sprite.get_child(current_select).hide()
	current_select -= 1
	
	if current_select < 0 or not $label_node.get_child(current_select).visible:
		for offset in range(MAX_OPTION):
			if $label_node.get_child(MAX_OPTION - 1 - offset).visible:
				current_select = MAX_OPTION - 1 - offset
				break
	
	$select_sprite.get_child(current_select).show()

func get_select():
	return $label_node.get_child(current_select).text

