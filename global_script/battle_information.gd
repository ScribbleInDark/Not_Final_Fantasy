class_name battle_information extends Node
var player_maker = PlayerEntity.new()
var weapon_entity_object = WeaponObject.new()

var player_side = [player_maker.make_fighter("test fighter"), player_maker.make_fighter("test warrior")]


"""
var player_side_hp = [10, 10]
var player_side_max_hp = [10, 10]
var player_side_name = ["bob", "nick"]

var player_level = [1, 1]
var player_exp = [0, 0]
"""

var player_target_array = [0, 0]
var player_action_array =[0, 0]


var enemy_side = []

var enemy_side_hp = [1]#, 10, 10]
var enemy_side_max_hp = [1]#, 10, 10]
var enemy_side_name = ["monster 1"]#, "monster 2", "monster 3"]
var enemy_action_array = [0]#, 0, 0]
var enemy_exp = [1]


func player_count():
	return len(player_side)

func enemy_count():
	return len(enemy_side)
	
	
func load_enemy(enemy_list):
	enemy_side.clear()
	enemy_side = enemy_list
