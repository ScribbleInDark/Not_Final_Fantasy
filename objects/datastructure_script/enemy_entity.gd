class_name EnemyEntity extends Resource


class enemy_entity:
	var name = "generic enemy"
	
	var sprite = "test"
	
	var slot_x = 0
	var slot_y = 0
	
	var hp = 10
	var max_hp = 10
	
	var moral = 9
	
	var level = 0
	var drop_table =null
	
	var ai_script = "basic_attack"
	
	# basic attack
	var attack_die = 6
	var attack_bonus = 0
	
	# basic defense
	var defense_die = 6
	var defense_bonus = 0
	
	# tags for combat
	
	# 10 harder to dodge
	var accurate_attack = false
	# 10 easier to dodge
	var inaccurate_attack = false
	
	# 10% harder to hit
	var small_target = false
	# 10% easier to hit
	var large_target = false
	
	#weakness mask
	#TODO if at all
	
	# spell ability stuff
	var cast_slot = 0
	var cast_array = ["place_holder", "place_holder"]
	
	# various other flags
	
	#revive die for things like skeletons
	var revive_die = 0
	
	# regeneration at end of round
	# this is turned off on fire or holy hit
	var regen_enabled = true
	var regen_die = 0
	
	# after hit poison
	var poison_die = 0
	
	# flag for species type
	var enemy_type = "humanoid"
	var poision_immune = false
	
	func _init(name, hp=10, damage=6, armor=4):
		self.name = name
		self.hp = hp
		self.max_hp = hp
		self.defense_die = damage
		self.defense_die = armor
		
		
	func can_poison():
		if poision_immune:
			return false
		return enemy_type == "humanoid" or enemy_type == "beast" or enemy_type == "dragon"
		

func number_process(entity, number):
	entity.name = "{name} {number}".format(
		{"name":entity.name, "number":number}
	)

func make_test_monster(number = 0):
	var out = enemy_entity.new("Monster", 4)
	out.sprite = "res://asset/enemy_battle_sprites/test_enemy_battle_sprite.png"
	if number:
		number_process(out, number)
	return out
	
func make_red_test_monster(number = 0):
	var out = enemy_entity.new("Red Monster", 5)
	out.sprite = "res://asset/enemy_battle_sprites/red_test_enemy.png"
	if number:
		number_process(out, number)
	return out
