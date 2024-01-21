class_name PlayerEntity extends Resource
#extends Node

var weapon_entity_object = WeaponObject.new()

class player_entity:
	var name = "testko"
	
	var level = 1
	var exp = 0
	
	var max_hp = 0
	var hp = 0
	
	var weapon = null
	var armor = null
	var shield = null
	
	var job_class = "bum"
	
	var stun = false
	
	var strength = 20
	var inteligence = 20
	var presence = 20
	var toughness = 20
	var agility = 20
	
	var white_cast = 0
	var max_white_cast = 0
	var black_cast = 0
	var max_black_cast = 0


func make_fighter(name):
	var out = player_entity.new()
	out.name = name
	out.job_class = "figheter"
	out.hp = 10
	out.max_hp = 10
	out.weapon = weapon_entity_object.iron_sword()
	return out
	
	
