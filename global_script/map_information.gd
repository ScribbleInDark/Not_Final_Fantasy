class_name map_information extends Node

"""
Class that keeps information for access by player object and is used to
transition scenes at proper way points
"""

# tiles that used for movement between maps
var transport_tile_list = []
var to_tile = null

func change_scene(new_scene, transport_name):
	"""
	Change the scene and reserve the transport tile name. When the new scene is
	loaded up the scene will call this to move player
	"""
	transport_tile_list.clear()
	
	to_tile = transport_name
	get_tree().change_scene_to_file(
					"res://objects/map_folder/{name}.tscn".format({"name":new_scene})
					)

func load_tiles(node_object):
	transport_tile_list = node_object.get_children()

func move_player(player_object):
	for item in transport_tile_list:
		if item.tile_number == to_tile:
			player_object.position = item.global_position
			# as tiles are top left
			player_object.position.x += 8
			player_object.position.y += 8
			
			break
	to_tile = null
