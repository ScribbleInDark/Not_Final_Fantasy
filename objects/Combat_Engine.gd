extends Node2D


# seconds for text scrawl
var text_speed = 1.0

var current_select = 0
var current_player = 0
# this turns on or off player input, turn back on after animation
var accept_input = true

# for randomization
var random = RandomNumberGenerator.new()

#base accuracy from palyer and enemies
var PLAYER_BASE_ACCURACY = 95
var ENEMY_BASE_ACCURACY = 90

# last pressed key
var g_key_pressed = false

# flags for options
var enemy_target = false
var player_target = false



# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	#BattleInformation.player_side_name[0] = "Knight"
	#BattleInformation.player_side_name[1] = "Fighter"
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not self.visible:
		return 
		
	if not accept_input:
		return
		
	if $action_menu.visible:
		if Input.is_action_just_pressed("ui_down"):
			$action_menu.menu_down()
		elif Input.is_action_just_pressed("ui_up"):
			$action_menu.menu_up()
		if Input.is_action_just_pressed("ui_accept"):
			var action_text = $action_menu.get_select()
			
			if action_text == "GUARD":
				do_guard_action(current_player)
				post_player_action_choice()
				turn_off_select()
			elif action_text == "MAJIK":
				BattleInformation.player_action_array[current_player] = 2
				post_player_action_choice()
				turn_off_select()
			else:
				#TODO
				# for now don't check player side
				enemy_target = true
				BattleInformation.player_action_array[current_player] = 0
				$action_menu.hide()
				target_for_current_player()
				
	elif enemy_target:
		# targeting 
		if Input.is_action_just_pressed("ui_down"):
			select_next_enemy()
		elif Input.is_action_just_pressed("ui_up"):
			select_prev_enemy()
		elif Input.is_action_just_pressed("ui_accept"):
			post_player_action_choice()
			turn_off_select()


func post_player_action_choice():
	current_player += 1
	accept_input = false
	$action_menu.hide()
	
	if current_player >= BattleInformation.player_count():
		do_round()
	else:
		# 
		var text = "SELECT ACTION FOR {name}".format(
				{"name": BattleInformation.player_side[current_player].name}
			)
		add_text(text)
		
		await get_tree().create_timer(text_speed).timeout
		accept_input = true
		$action_menu.show()


func setup_player():	
	var player_children = $player_side.get_children()
	
	for node in player_children:
		node.hide()
	
	for index in range(BattleInformation.player_count()):
		player_children[index].show()
		
		BattleInformation.player_target_array[index] = 0
		BattleInformation.player_action_array[index] = 0
	
		# charcter sprite

func setup_enemy(enemy_array):
	var enemy_children = $enemy_side.get_children()
	
	for child in enemy_children:
		child.hide()
	
	for index in range(len(enemy_array)):
		# monster sprite
		#TODO cache this somewehre
		var texture = load(enemy_array[index].sprite)
		enemy_children[index].get_node("Sprite2D").set_texture(texture)
		enemy_children[index].show()
		# set offsets
		#enemy_children[index].

func setup_battle(enter_text="YOU ENCOUTNER AN ENEMY", ambush=false):
	# reset base engine information
	current_player = 0
	current_select = 0
	accept_input = false
	$action_menu.hide()
	
	if ambush:
		add_text(enter_text)
	else:
		# find the first character alive and say they shoudl do an action
		for index in range(BattleInformation.player_count()):
			if BattleInformation.player_side[index].hp > 0:
				var text = "{ENTER_TEXT}\nCHOOSE ACTION FOR {name}".format(
						{"ENTER_TEXT": enter_text,"name": BattleInformation.player_side[index].name}
					)
				add_text(text)
				break
	
	for index in range(BattleInformation.player_count()):
		update_player_health_and_name(index)
	
	await get_tree().create_timer(text_speed).timeout
	
	accept_input = true
	setup_action_menu()
	
	
func setup_action_menu():
	$action_menu.show()
	$action_menu.setup_text(["ATTACK", "GUARD", "MAJIK"])
	turn_off_select()


func target_for_current_player():
	
	var current_enemy = BattleInformation.player_target_array[current_player]
	
	var enemy_len = BattleInformation.enemy_count()
	for offset in range(enemy_len):
		var target = (current_enemy + offset) % enemy_len
		if BattleInformation.enemy_side[target].hp < 1:
			continue
		set_select_enemy(target)
		BattleInformation.player_target_array[current_player] = target
		break
		
func do_guard_action(player):
	# this is for doing guard action
	BattleInformation.player_action_array[player] = 1

func select_next_enemy():
	var current_enemy = BattleInformation.player_target_array[current_player]
	
	var enemy_len = BattleInformation.enemy_count()
	for offset in range(enemy_len):
		var target = (current_enemy + offset + 1) % enemy_len
		if BattleInformation.enemy_side[target].hp < 1:
			continue
		set_select_enemy(target)
		BattleInformation.player_target_array[current_player] = target
		break
		
func select_prev_enemy():
	var current_enemy = BattleInformation.player_target_array[current_player]
	
	var enemy_len = BattleInformation.enemy_count()
	for offset in range(enemy_len):
		var target = (current_enemy - offset - 1) % enemy_len
		if target < 0:
			target = enemy_len + target
		if BattleInformation.enemy_side[target].hp < 1:
			continue
		set_select_enemy(target)
		BattleInformation.player_target_array[current_player] = target
		break
		
func end_combat():
	"""
	End combat and persist data to a given parent node and then hide 
	the whole combat scene 
	"""
	
	add_text("Combat is over")
	accept_input = false
	await get_tree().create_timer(text_speed).timeout
	
	var total_exp = 0
	for exp in BattleInformation.enemy_exp:
		total_exp += exp
	
	for index in range(BattleInformation.player_count()):
		if BattleInformation.player_side[index].hp < 1:
			continue
		var exp = BattleInformation.player_side[index].exp + total_exp
		if exp >= BattleInformation.player_side[index].level * 5:
			BattleInformation.player_side[index].level += 1
			BattleInformation.player_side_max_hp[index] += 1
			BattleInformation.player_side[index].exp = exp
			
			var text = "{name} LEVELED UP TO {level}".format(
				{"name":BattleInformation.player_side[index].name, 
				"level":BattleInformation.player_side[index].level}
			)
			add_text(text)
			update_player_health_and_name(index)
			await get_tree().create_timer(text_speed).timeout
		else:
			BattleInformation.player_side[index].exp = exp
			var text = "{name} EXP HAS INCREASED TO {exp}".format(
				{"name":BattleInformation.player_side[index].name, 
				"exp":BattleInformation.player_side[index].exp}
			)
			add_text(text)
			await get_tree().create_timer(text_speed/2).timeout
		

	# hide combat window
	get_parent().hide()
	
func is_combat_over():
	"""
	check that combatis over by itterating through both player and enemies
	hp and returns true if either side is dead
	TODO make this return which one through some sorta state constnat 
	"""
	
	var player_alive = false
	var enemy_alive = false
	
	for index in range(BattleInformation.player_count()):
		if BattleInformation.player_side[index].hp > 0:
			player_alive = true
	if not player_alive:
		return true

	for index in range(BattleInformation.enemy_count()):
		if BattleInformation.enemy_side[index].hp > 0:
			enemy_alive = true
	if not enemy_alive:
		return true
	return false
	
func do_round():
	"""
	Turn off seleciton and then go through player actions and enemy actions
	use awaits to let players read text and possible TODO sfx assoicated
	with actions. After each action is done check if combat is over and end
	combat and exit if so.
	"""
	
	turn_off_select()
	$action_menu.hide()
	
	accept_input = false
	for index in range(BattleInformation.player_count()):
		if BattleInformation.player_side[index].hp < 1:
			continue
		if BattleInformation.player_action_array[index] == 1:
			# do guard
			var message = "{name} GUARDS!".format({"name": BattleInformation.player_side[index].naem})
			add_text(message)
		elif BattleInformation.player_action_array[index] == 2:
			do_aoe_magic_attack(index)
		else:
			do_player_attack(index, BattleInformation.player_target_array[index])
		await get_tree().create_timer(text_speed).timeout
		if is_combat_over():
			
			end_combat()
			return

	for index in range(BattleInformation.enemy_count()):
		if BattleInformation.enemy_side[index].hp < 1 or not is_living_player():
			continue
		do_enemy_attack(index, get_living_player_index())
		await get_tree().create_timer(text_speed).timeout
		if is_combat_over():
			end_combat()
			return

	
	# get next living player for action selection
	for index in range(BattleInformation.player_count()):
		if BattleInformation.player_side[index].hp < 1:
			
			continue
		var text = "SELECT ACTION FOR {name}".format(
				{"name": BattleInformation.player_side[index].name}
			)
		add_text(text)
		current_player = index
		break
	await get_tree().create_timer(text_speed).timeout
	accept_input = true
	setup_action_menu()
	

func is_living_player():
	for player in BattleInformation.player_side:
		if player.hp>0:
			return true
	return false
	
func get_living_player_index():
	var party_count = BattleInformation.player_count()
	var roll = random.randi_range(0, party_count-1)
	if BattleInformation.player_side[roll].hp > 0:
		return roll
	
	for offset in range(party_count):
		var modified = (roll + offset) % party_count
		if BattleInformation.player_side[modified].hp > 0:
			return modified
	return roll


func get_enemy_name(index):
	return BattleInformation.enemy_side[index].name
	
func get_player_name(index):
	return BattleInformation.player_side[index].name
	
func set_select_enemy(index):
	var child_node = $enemy_side.get_child(index)
	$selector.show()
	
	$selector.position.x = child_node.position.x-8
	$selector.position.y = child_node.position.y

func turn_off_select():
	$selector.hide()

func turn_on_select():
	$selector.show()
	
func d100_test(target):
	return random.randi_range(1, 100) <= target
	
func do_player_hit(player_index, target_index, penalty=0):
	"""
	Players have a base 95% accuracy
	"""
	var roll = random.randi_range(1, 100)
	print_debug("HIT ROLL", roll)
	var target_number = 60
	target_number += BattleInformation.player_side[player_index].strength
	
	print_debug(roll, " ", target_number-penalty, " ? ", roll <= (target_number-penalty))
	
	return roll <= (target_number-penalty)

func do_player_attack(player_index, target_index):
	
	$player_side.get_child(player_index).attack_left(.10)
	if not do_player_hit(player_index, target_index):
		var text = "{player} missed {monster}".format({
			"player":get_player_name(player_index),
			"monster":get_enemy_name(target_index)}
			)
		add_text(text)
		return

	var hit_count = 1
	var damage = 0
	var player = BattleInformation.player_side[player_index]
	var target = BattleInformation.enemy_side[target_index]
	var penalty = 0
	var poison_check = false
	
	var armor_reduction = 0
	
	while true:
		if player.weapon == null:
			# bar fists
			damage = random.randi_range(1, 3)
			damage += min(damage, random.randi_range(1, 3))
			if player.job_class == "monk":
				damage += 1
				damage += player.strength / 30
				armor_reduction = random.randi_range(0, 1)
			elif player.strength > 70:
				damage += 1
		else:
			# basic weapon stuff
			damage += random.randi_range(1, player.weapon.damage_die)
			# class based additions
			if player.job_class == "fighter":
				damage += 1
				damage += player.strength / 30
			else:
				damage += player.strength / 50
			
			# do other damage and effect things here based on weapon type.
			if player.weapon.activate_bane(target.enemy_type):
				random.randi_range(1, player.weapon.damage_die)
				
			if player.weapon.penetration_die:
				armor_reduction = random.randi_range(1,player.weapon.penetration_die)
				
			if player.weapon.poison_die and target.can_poison():
				if d100_test(20 + player.agility):
					poison_check = true
			
		# do enemy armor reduction
		if target.defense_die > 0:
			damage -= max(0, random.randi_range(1, target.defense_die) - armor_reduction)
		damage -= target.defense_bonus
		
		# poison can only flag once but each hit is a check
		if poison_check:
			damage += random.randi_range(1, player.weapon.poison_die)
		
		if damage < 1:
			# pitty
			if d100_test(20 + player.strength):
				damage = 1
			else:
				damage = 0
		
				
		penalty += 40
		if not do_player_hit(player_index, target_index, penalty):
			break
		hit_count += 1
	
	BattleInformation.enemy_side[target_index].hp -= damage
	
	if damage == 0:
		var text = "{user} was unable to inflict damage on {target}!".format(
			{"user":get_player_name(player_index), 
			"target":get_enemy_name(target_index)}
		)
		add_text(text)
	elif BattleInformation.enemy_side[target_index].hp < 1:
		$enemy_side.get_child(target_index).death_blink(2)
		var text = "{target} was slain!".format({"target":get_enemy_name(target_index)})
		add_text(text)
	else:
		var text = "hit text"
		if hit_count > 1:
			text = "{user} hit {count} times and did {damage} damage to {target}".format(
				{"user":get_player_name(player_index), 
				"damage":damage,
				"count":hit_count,
				"target":get_enemy_name(target_index)})
			
		else:
			text = "{user} did {damage} damage to {target}".format(
				{"user":get_player_name(player_index), 
				"damage":damage, 
				"target":get_enemy_name(target_index)})
		add_text(text)
		
func do_aoe_magic_attack(player_index):
	var monster_hit = 0
	var total_damage = 0
	for index in range(BattleInformation.enemy_count()):
		if BattleInformation.enemy_side[index].hp < 1:
			continue
		monster_hit += 1
		var damage = random.randi_range(1, 6)
		total_damage += damage
		BattleInformation.enemy_side[index].hp -= damage
		if BattleInformation.enemy_side[index].hp < 1:
			$enemy_side.get_child(index).hide()
	var text = "{user} cast spell for an average of {damage}".format(
			{"user":get_player_name(player_index), "damage":total_damage/monster_hit}
		)
	add_text(text)


func do_enemy_hit(player_index, target_index):
	""" 
	Enemies have a base accuracy of 90 to miss players more
	"""
	var roll = random.randi_range(1, 100)
	return roll <= 90


func do_enemy_attack(enemy_index, target_index):
	var enemy = BattleInformation.enemy_side[enemy_index]
	var player = BattleInformation.player_side[target_index]
	
	if not do_enemy_hit(enemy_index, target_index):
		var text = "{monster} missed {player}!".format({
			"player":get_player_name(target_index),
			"monster":get_enemy_name(enemy_index)}
			)
		add_text(text)
		return
	
	var damage = random.randi_range(1, enemy.attack_die)
	# check if target is doing a form of physical guarding
	if BattleInformation.player_action_array[target_index] == 1:
		damage /= 2
	
	# check player armor and shield
	if player.armor != null:
		damage -= random.randi_range(1, player.armor.armor_die)
		damage -= player.armor.damage_reduction
		#TODO any special aditiona reduction
	
	if player.shield != null:
		damage -= random.randi_range(1, player.shield.armor_die)
		damage -= player.shield.damage_reduction
		#TODO any special sheild reduction
	if damage < 1:
		damage = 0
		if d100_test(50):
			damage = 1
	player.hp -= damage

	if damage == 0:
		var text = "{monster} was unable to inflict damage on {player}!".format(
			{"target":get_player_name(target_index),
			"monster":get_enemy_name(enemy_index)
			})
		add_text(text)
	elif player.hp < 1:
		$player_side.get_child(target_index).hide()
		var text = "{monster} attacked and {target} fell!!!".format({
			"target":get_player_name(target_index),
			"monster":get_enemy_name(enemy_index)})
		add_text(text)
	else:
		var text = "{user} did {damage} damage to {target}".format(
			{"user":get_enemy_name(enemy_index), 
			"damage":damage, 
			"target":get_player_name(target_index)})
		add_text(text)
	update_player_health_and_name(target_index)


func add_text(text):
	$text_log.text = text
	
func update_player_health_and_name(index):
	var node = $player_side.get_child(index)
	node.get_node("name_label").text = get_player_name(index)
	var health_string = "{current}/{max}".format(
		{"current":BattleInformation.player_side[index].hp, 
		"max":BattleInformation.player_side[index].max_hp})
	node.get_node("health_label").text = health_string
	if BattleInformation.player_side[index].hp < 1:
		node.get_node("Sprite").hide()
	else:
		node.get_node("Sprite").show()
