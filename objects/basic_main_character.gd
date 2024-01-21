extends Node2D


var move_horizontal = 16
var move_vertical = 16

var map_collision_tile = 0b00000000_00000000_00000000_00000001
var map_change_tile = 0b00000000_00000000_00000000_00100000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func move_action():
	
	# wait for everyting to fix itself
	if $black_out.visible:
		return

	# 4 way movement
	var x_offset = 0
	var y_offset = 0
	# left right toggle
	if Input.is_action_just_pressed("ui_left"):
		x_offset = -move_horizontal
	elif Input.is_action_just_pressed("ui_right"):
		x_offset = move_horizontal
	# up down toggle
	elif Input.is_action_just_pressed("ui_up"):
		y_offset = -move_vertical
	elif Input.is_action_just_pressed("ui_down"):
		y_offset = move_vertical
	# check if collision
	
	if x_offset or y_offset:
		if not check_move(position.x + x_offset, position.y + y_offset):
			var offset_x_normal = x_offset / move_horizontal
			var offset_y_normal = y_offset / move_vertical
			
			#TODO for fancy movement turn back on
			#for index in range(move_horizontal):
			#	position.x += offset_x_normal
			#	position.y += offset_y_normal	
			#	await get_tree().create_timer(0.016).timeout
			position.x += x_offset
			position.y += y_offset
			return true
	return false


func check_move(target_x,target_y):
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	#print_debug(position.x, ",", position.y, " | ", target_x,",", target_y)
	var query = PhysicsRayQueryParameters2D.create(
				Vector2(position.x, position.y), 
				Vector2(target_x, target_y),
				map_collision_tile
				)
	var result = space_state.intersect_ray(query)
	return len(result) > 1
	
func check_move_tile_on():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
				Vector2(position.x, position.y), 
				Vector2(position.x+4, position.y+4),
				map_change_tile
				)
	query.hit_from_inside = true
	var result = space_state.intersect_ray(query)
	if len(result) > 0:
		return result["collider"]
	return null
	

func turn_off_blackout():
	$black_out.hide()
	$Camera2D.position_smoothing_enabled = true
	
func spawn_wait():
	$black_out.show()
	$Camera2D.position_smoothing_enabled = false
	await get_tree().create_timer(.25).timeout
	turn_off_blackout()
