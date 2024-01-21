class_name WeaponObject extends Resource


class weapon_object:
	
	var name = "test weapon"
	var hit_bonus = 0
	var damage_die = 6
	var damage_bonus = 0
	
	var penetration_die = 0
	var poison_die = 0
	# use in addition to other armor reduction
	var defending_die = 0
	
	
	
	
	# damgae is 50/50 1 or max die damage
	var hi_or_low = false
	# for items such as fire swords or silver weapons
	var seal_regeneration = false
	
	# roll damgae die twice agaisnt certain tarets 
	var human_bane = false
	var beast_bane = false
	var devil_bane = false
	var dragon_bane = false
	var chaos_bane = false
	var magic_bane = false
	var undead_bane = false
	var construction_bane = false
	
	
	func _init(name, face):
		name = name
		damage_die = face
		
	func activate_bane(enemy_type):
		if human_bane and enemy_type == "humanoid":
			return true
		elif beast_bane and enemy_type == "beast":
			return true
		elif devil_bane and enemy_type == "demon":
			return true
		elif dragon_bane and enemy_type == "dragon":
			return true
		elif chaos_bane and enemy_type == "chaos":
			return true
		elif magic_bane and enemy_type == "elemental":
			return true
		elif undead_bane and enemy_type == "undead":
			return true
		elif construction_bane and enemy_type == "construct":
			return true
		return false
	


func iron_sword():
	var out = weapon_object.new("Iron Sword", 6)
	return out
	
func iron_dagger():
	var out = weapon_object.new("Iron Dagger", 4)
	out.hit_bonus = 20
	return out

func iron_mace():
	var out = weapon_object.new("Iron Mace", 4)
	out.penetration_die = 4
	return out
	
func iron_flail():
	var out = weapon_object.new("Iron Flail", 8)
	out.all_or_nothing = true
	return out

# magic weapons
func dagger_of_murder():
	var out = weapon_object.new("Murder Dagger", 4)
	out.hit_bonus = 20
	out.damage_bonus = 1
	out.human_bane = true
	return out

func hunter_spear():
	var out = weapon_object.new("Hunter spear", 8)
	out.beast_bane = true
	out.dragon_bane = true
	return out
	
func dragon_slayer_sword():
	var out = weapon_object.new("Dragon Slayer Sword", 6)
	out.dragon_bane = true
	out.damage_bonus = 2
	return out

func sun_sword():
	var out = weapon_object.new("Sun Sword", 6)
	out.damage_bonus = 1
	out.undead_bane = true
	return out
	
func serpent_sword():
	var out = weapon_object.new("Serpent Sword", 6)
	out.poison_die = 4
	return out

func poison_dagger():
	var out = weapon_object.new("Poison Dagger", 4)
	out.hit_bonus = 20
	out.poison_die = 6
	return out
	
func venom_dagger():
	var out = weapon_object.new("Venom Dagger", 4)
	out.hit_bonus = 20
	out.poison_die = 12
	out.human_bane = true
	out.beast_bane = true
	return out
	
func disruption_mace():
	var out = weapon_object.new("Disruption Mace", 4)
	out.penetration_die = 4
	out.devil_bane = true
	out.chaos_bane = true
	out.magic_bane = true
	out.construction_bane = true
	return out
