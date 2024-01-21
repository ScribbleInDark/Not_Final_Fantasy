extends Node2D

var enemy_entity_object = EnemyEntity.new()


var player_information_list =[
	["Knight",10, 10],
	["Fighter",10, 10]
]

var random = RandomNumberGenerator.new()
var step_count = 0
# Called when the node enters the scene tree for the first time.

func _ready():
	random.randomize()
	
	MapInformation.load_tiles($map_collisions)
	
	if MapInformation.to_tile:
		$player_character.spawn_wait()
		MapInformation.move_player($player_character)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""
	only active if combat is not visible otherwise let player move around
	"""
	
	if not $Combat_scene.visible:
		
		if $player_character.move_action():
			#TODO fix up
			var steped_on = $player_character.check_move_tile_on()
			if steped_on != null:
				MapInformation.change_scene(steped_on.to_map_name, steped_on.to_map_tile)
				return
		#if $player_character.move_action():
		#	step_count += 1
		#TODO remove me
		return
		if step_count > 3:
			step_count = 0
			run_combat()
			

func run_combat():

	var enemy_info = [enemy_entity_object.make_test_monster()]
	if random.randi_range(1,6) != 2:
		enemy_info = [enemy_entity_object.make_test_monster(), enemy_entity_object.make_red_test_monster()]
	BattleInformation.load_enemy(enemy_info)
	$Combat_scene.get_node("Combat_Engine").setup_player()
	$Combat_scene.get_node("Combat_Engine").setup_enemy(enemy_info)
	$Combat_scene/Combat_Engine.setup_battle()
	$Combat_scene.show()


func persist_data(update_array):
	player_information_list = update_array
