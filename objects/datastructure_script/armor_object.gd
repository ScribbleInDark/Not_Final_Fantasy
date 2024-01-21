class_name ArmorObject extends Resource


class armor_object:
	var name = "test armor"
	
	var armor_die = 4
	var damage_reduction = 0
	var dodge_modifier = 0
	var cast_penalty = 0
	
	# various flags
	
	# double against
	var resist_fire = false
	var resist_ice = false
	var resist_elec = false
	var resist_dark = false
	var resist_holy = false
	
	# inflicted status immunity
	var poison_immune = false
	var death_immune = false
	var stun_immune = false
	
	var regen_die = 0
	

	func _init(name, armor, reduction):
		self.name = name
		self.armor_die = armor
		if armor_die >= 6:
			self.cast_peantly = -10 * armor_die
		elif armor_die == 4:
			self.cast_penalty = -20
		self.damage_reduction = reduction
